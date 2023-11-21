resource "google_workflows_workflow" "store_wfk" {
  name            = "store_wfk"
  region          = "europe-west1"
  source_contents = file("../cloud_workflows/store_wkf.yaml")
}