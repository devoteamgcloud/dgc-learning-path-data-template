# resource "google_workflows_workflow" "store_workflow" {
#   project         = var.project_id
#   name            = "store_wkf"
#   region          = var.region
#   source_contents = file("../cloud_workflows/store_wkf.yaml")
# }

# resource "google_workflows_workflow" "customer_staging_workflow" {
#   project         = var.project_id
#   name            = "customer_wkf"
#   region          = var.region
#   source_contents = file("../cloud_workflows/customer_wkf.yaml")
# }

#locals {
#  all_files_t = fileset(path.module, "../cloud_workflows/**")
#}

resource "google_workflows_workflow" "workflows" {
  for_each        = local.all_files_t
  project         = var.project_id
  name            = trimsuffix(trimprefix(each.value, "../cloud_workflows/"), ".yaml")
  region          = var.region
  source_contents = file(each.value)
}

