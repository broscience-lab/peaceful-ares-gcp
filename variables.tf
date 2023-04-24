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
