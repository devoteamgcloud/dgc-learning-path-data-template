resource "google_workflows_workflow" "store_wkf" {
  project = var.project_id
  name = "store_wkf"
  region = var.region
  description = "the Workflows store_wkf"
  source_contents = file("../cloud_workflows/store_wkf.yaml")
}

resource "google_workflows_workflow" "customer_wkf" {
  project = var.project_id
  name = "customer_wkf"
  region = var.region
  description = "the Workflows customer_wkf"
  source_contents = file("../cloud_workflows/customer_wkf.yaml")
}