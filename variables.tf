variable "gcp_project" {
  description = "Name of the project within GCP"
  type        = string
}

variable "gcp_region" {
  description = "Region of deployed resources in GCP"
  type        = string
}

variable "gcp_zone" {
  description = "Zone of deployed resources in GCP"
  type        = string
}


variable "gcs_bucket_name" {
  description = "Name of the Google Cloud Storage (GCS) bucket"
  type        = string
}

variable "gar_repository_id" {
  description = "Repository id of the Google Artifact Registry (GAR)"
  type        = string
}

variable "cloud_run_name" {
  description = "Name of the Cloud Run Service"
  type        = string
}


variable "cloud_run_image_name" {
  description = "Name of image run by the Cloud Run Service"
  type        = string
}


variable "cloud_run_image_tag" {
  description = "Tag of the pulled image"
  type        = string
}

variable "cloud_run_container_port" {
  description = "Container port of image run by Cloud Run"
  type        = number
}

variable "cloud_run_domain_map" {
  description = "Domains for which to create a Cloud Run domain map"
  type        = list(string)
  default     = ["broscience.xyz", "www.broscience.xyz"]
}
