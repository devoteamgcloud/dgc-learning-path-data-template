resource "google_workflows_workflow" "workflow_store" {
    name            = "store_wkf"
    project         = var.project_id
    region          = var.region
    source_contents = file("../cloud_workflows/store_wkf.yaml")
}