resource "google_workflows_workflow" "store_wkf" {
  project = var.project_id
  name = "store_wkf"
  region = var.region
  description = "the Workflows store_wkf"
  source_contents = file("../cloud_workflows/store_wkf.yaml")
}