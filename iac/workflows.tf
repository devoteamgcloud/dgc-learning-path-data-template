# https://cloud.google.com/workflows/docs/create-workflow-terraform

provider "google" {
 project = var.project_id
}

# enable the workflow API
resource "google_project_service" "workflows" {
  service            = "workflows.googleapis.com"
  disable_on_destroy = false
}

# Create a service account for the workflow
resource "google_service_account" "workflows_service_account" {
  account_id   = "sample-workflows-sa"
  display_name = "Sample Workflows Service Account"
}

# Define and deploy the store workflow
resource "google_workflows_workflow" "store_wkf" {
  project         = var.project_id
  name            = "store_wkf"
  region          = "europe-west1"
  description     = "A store workflow"
  service_account = google_service_account.workflows_service_account.id
  source_contents =  file("../cloud_workflows/store_wkf.yaml")
  depends_on = [google_project_service.workflows]
}

# Define and deploy the customer workflow
resource "google_workflows_workflow" "customer_wkf" {
  project         = var.project_id
  name            = "customer_wkf"
  region          = "europe-west1"
  description     = "A customer workflow"
  service_account = google_service_account.workflows_service_account.id
  source_contents =  file("../cloud_workflows/customer_wkf.yaml")
  depends_on = [google_project_service.workflows]
}

# Define and deploy the basket workflow
resource "google_workflows_workflow" "basket_wkf" {
  project         = var.project_id
  name            = "basket_wkf"
  region          = "europe-west1"
  description     = "A basket workflow"
  service_account = google_service_account.workflows_service_account.id
  source_contents =  file("../cloud_workflows/basket_wkf.yaml")
  depends_on = [google_project_service.workflows]
}