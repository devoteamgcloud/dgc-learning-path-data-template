resource "google_project_service" "workflow" {
  project            = var.project_id
  service            = "workflows.googleapis.com"
  disable_on_destroy = false
}


resource "google_workflows_workflow" "worflows" {  
  project         = var.project_id
  region          = "europe-west1"
  source_contents = "../cloud_workflows/store_wkf.yaml"
  name            = "store_wkf.yaml"
}