resource "google_workflows_workflow" "store_wfk" {
  for_each        = fileset("../cloud_workflows", "**")
  name            = each.value
  region          = "europe-west1"
  source_contents = file("../cloud_workflows/${each.value}")
}