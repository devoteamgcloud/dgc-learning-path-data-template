resource "google_workflows_workflow" "workflows" {
  for_each        = local.all_files_t
  project         = var.project_id
  name            = trimsuffix(trimprefix(each.value, "../cloud_workflows/"), ".yaml")
  region          = var.region
  source_contents = file(each.value)
}

