resource "google_workflows_workflow" "worflows" {  
  for_each        = fileset(path.module, "../{cloud_workflows}/**")
  project         = var.project_id
  region          = "${var.location}"
  name            = trim(each.value, "../")
  source_contents = each.value
}