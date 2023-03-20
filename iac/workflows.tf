# enable the workflow API
resource "google_project_service" "workflows" {
  
  service            = "workflows.googleapis.com"
  disable_on_destroy = false
}
resource "google_service_account" "workflows_service_account" {
  project = var.project_id
  account_id   = "sample-workflows-sa"
  display_name = "Sample Workflows Service Account"
}
resource "google_workflows_workflow" "store_workflow" {
  project = var.project_id
  name          = "store_wkf"
  region        = var.region
  description   = "Workflow source data"
  service_account = google_service_account.workflows_service_account.id
  source_contents = file("../cloud_workflows/store_wkf.yaml")
  depends_on = [
    google_project_service.workflows
  ]
}