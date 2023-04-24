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

resource "google_artifact_registry_repository" "broscience_registry" {
  location      = var.gcp_region
  repository_id = "${var.gcp_project}-registry"
  description   = "Docker registry for storing docker images for webapp"
  format        = "DOCKER"
}
