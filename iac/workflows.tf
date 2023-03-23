# enable the workflow API
resource "google_workflows_workflow" "store_workflow" {
  project = var.project_id
  name          = "store_wkf"
  region        = var.region
  description   = "Workflow source data"
  source_contents = file("../cloud_workflows/store_wkf.yaml")
}
resource "google_workflows_workflow" "customer_workflow" {
  project = var.project_id
  name          = "customer_wkf"
  region        = var.region
  description   = "Workflow source data"
  source_contents = file("../cloud_workflows/customer_wkf.yaml")
}
resource "google_workflows_workflow" "basket_workflow" {
  project = var.project_id
  name          = "basket_wkf"
  region        = var.region
  description   = "Workflow source data"
  source_contents = file("../cloud_workflows/basket_wkf.yaml")
}