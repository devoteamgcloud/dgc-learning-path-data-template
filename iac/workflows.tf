#resource "google_project_service" "workflows" {
#    service = "workflows.googleapis.com"
#    disable_on_destroy = false
#}
#resource "google_service_account" "workflows_service_account" {
#  account_id   = "sample-workflows-sa"
# display_name = "Sample Workflows Service Account"
#}
resource "google_workflows_workflow" "workflows_store" {
  project = var.project_id
  name            = "store-workflow"
  region          = "europe-west1"
  description     = "A sample workflow"
  source_contents = file("../cloud_workflows/store_wkf.yaml")
}

#resource "google_workflows_workflow" "store_workflow" {
#  project         = var.project_id
#  name            = "store_wkf"
#  region          = var.region
#  source_contents = file("../cloud_workflows/store_wkf.yaml")
#}