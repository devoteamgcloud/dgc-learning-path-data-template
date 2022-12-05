resource "google_workflows_workflow" "store_workflow" {
  project         = var.project_id
  name            = "store_wkf"
  region          = var.region
  source_contents = file("../cloud_workflows/store_wkf.yaml")
}