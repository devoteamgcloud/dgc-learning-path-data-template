# enable the workflow API
resource "google_project_service" "workflows" {
  project = var.project_id
  service            = "workflows.googleapis.com"
  disable_on_destroy = false
}
resource "google_service_account" "workflow_account" {
  project = var.project_id
  account_id   = "wkf-sa"
  display_name = "Workflow Service Account"
  depends_on = [
    google_project_service.workflows
  ]
}
resource "google_workflows_workflow" "store_workflow" {
  project = var.project_id
  name          = "store_wkf"
  region        = var.region
  description   = "Workflow source data"
  service_account = google_service_account.workflow_account.account_id
  source_contents = file("../cloud_workflows/store_wkf.yaml")
  depends_on = [
    google_project_service.workflows
  ]
}