terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

# Terraform uses GOOGLE_CREDENTIALS variable to authenticate with GCP.
# The variable should contain the key file of a service account with
# appropriate permissions.
provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

# Setup bucket to store terraform state
resource "google_storage_bucket" "default" {
  name          = "${random_id.bucket_prefix.hex}-${var.gcs_bucket_name}"
  force_destroy = false
  location      = "EU"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

resource "google_artifact_registry_repository" "peaceful_ares_registry" {
  location      = var.gcp_region
  repository_id = "${var.gcp_project}-registry"
  description   = "Docker registry for storing docker images for webapp"
  format        = "DOCKER"
}

resource "google_cloud_run_v2_service" "webapp_cloudrun_service" {
  name     = var.cloud_run_name
  location = var.gcp_region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project}/${var.gar_repository_id}/${var.cloud_run_image_name}:"
      ports {
        container_port = var.cloud_run_container_port
      }
      resources {
        limits = {
          cpu    = "1",
          memory = "128Mi"
        }
        cpu_idle = true
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 2
    }
  }
}

resource "google_cloud_run_domain_mapping" "broscience_xyz_domain" {
  location = var.gcp_region
  name     = var.cloud_run_domain_map[0]

  metadata {
    namespace = var.gcp_project
  }

  spec {
    route_name = google_cloud_run_v2_service.webapp_cloudrun_service.name
  }
}

resource "google_cloud_run_domain_mapping" "www_broscience_xyz_domain" {
  location = var.gcp_region
  name     = var.cloud_run_domain_map[1]

  metadata {
    namespace = var.gcp_project
  }

  spec {
    route_name = google_cloud_run_v2_service.webapp_cloudrun_service.name
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_v2_service.webapp_cloudrun_service.location
  project  = google_cloud_run_v2_service.webapp_cloudrun_service.project
  service  = google_cloud_run_v2_service.webapp_cloudrun_service.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

moved {
  from = google_artifact_registry_repository.broscience_registry
  to   = google_artifact_registry_repository.peaceful_ares_registry
}
