resource "google_project_service" "workflow" {
  project            = var.project_id
  service            = "workflows.googleapis.com"
  disable_on_destroy = false
}


resource "google_workflows_workflow" "worflows" {  
  for_each        = fileset(path.module, "../{cloud_workflows}/**")
  project         = var.project_id
  region          = "europe-west1"
  name            = trim(each.value, "../")
  source          = each.value
}