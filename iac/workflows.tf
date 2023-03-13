resource "google_workflows_workflow" "store_wkf" {
  name          = "workflow"
  region        = "europe-west1"
  source_contents = "../cloud_workflows/store_wkf.yaml"
}