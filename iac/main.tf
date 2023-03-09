# we declare the connection to the google provider
provider "google" {
  project = var.project_id
  region  = var.region
  #impersonate_service_account = var.tf_service_account
}