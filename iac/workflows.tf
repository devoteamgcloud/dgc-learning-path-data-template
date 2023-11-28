resource "google_workflows_workflow" "workflows" {
  for_each        = fileset("../cloud_workflows", "**")
  name            = split(".", each.value)[0]
  region          = "europe-west1"
  source_contents = file("../cloud_workflows/${each.value}")
}