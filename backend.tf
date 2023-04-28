terraform {
  # pass backend configs using -backend-config=backend.conf or by passing them
  # as arguments when running `terraform init`
  backend "gcs" {}
}
