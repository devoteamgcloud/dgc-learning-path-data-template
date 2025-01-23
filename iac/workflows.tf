resource "google_workflows_workflow" "store_wkf" {
  project         = var.project_id
  name            = "store_wkf"
  description     = "SQL query store workflow"
  region          = var.region
  source_contents = file("../cloud_workflows/store_wkf.yaml")
}

# resource "google_workflows_workflow" "customer_wkf" {
#   project         = var.project_id
#   name            = "customer_wkf"
#   description     = "SQL query customer workflow"
#   region          = var.region
#   source_contents = file("../cloud_workflows/customer_wkf.yaml")
# }