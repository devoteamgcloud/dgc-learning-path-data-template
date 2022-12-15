resource "google_workflows_workflow" "store_workflow" {
  project         = var.project_id
  name            = "store_wkf"
  region          = var.region
  source_contents = file("../cloud_workflows/store_wkf.yaml")
}

resource "google_workflows_workflow" "customer_staging_workflow" {
  project = var.project_id
  name = "customer_staging_wkf"
  region = var.region
  source_contents = file("../cloud_workflows/customer_wkf.yaml")  
}