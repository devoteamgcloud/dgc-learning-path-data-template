resource "google_service_account" "workflow_account" {
  account_id   = "wkf_sa"
  display_name = "Workflow Service Account"
}
resource "google_workflows_workflow" "store_workflow" {
  name          = "store_wkf"
  region        = var.region
  description   = "Workflow source data"
  service_account = google_service_account.workflow_account.account_id
  source_contents = file("../cloud_workflows/store_wkf.yaml")
}