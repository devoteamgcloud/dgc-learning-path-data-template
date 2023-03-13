# we declare the connection to the google provider
provider "google" {
  project = var.project_id
  region  = var.region
  #need to set credential in the provider block (terraform plan error)
  #credentials = var.gcp_credentials
  #impersonate_service_account = var.tf_service_account
}