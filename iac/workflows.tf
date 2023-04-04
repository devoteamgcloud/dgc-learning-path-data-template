
resource "google_workflows_workflow" "workflows" {
  for_each        = fileset(path.module, "../cloud_workflows/*.yaml")
  project         = var.project_id
  name            = trimsuffix(basename(each.value), ".yaml")
  region          = var.region
  source_contents = file(each.value)
}
