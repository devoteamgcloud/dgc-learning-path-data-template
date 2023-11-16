resource "google_workflows_workflow" "store_wfk" {
  name          = "store_wfk"
  region        = "europe-west1"
  source_contents = "/Users/vvaneeclo/Projects/dgc-learning-path-data/dgc-learning-path-data-template/cloud_workflows/store_wkf.yaml"
}
