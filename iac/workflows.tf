resource "google_project_service" "workflows" {
  service            = "workflows.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "workflows_service_account" {
  account_id   = "sample-workflows-sa"
  display_name = "Sample Workflows Service Account"
}

resource "google_workflows_workflow" "store_wkf" {
  name            = "sample-workflow"
  region          = "us-central1"
  description     = "A sample workflow"
  service_account = google_service_account.workflows_service_account.id
  source_contents = file("../cloud_workflows/store_wkf.yaml")
  depends_on = [google_project_service.workflows]
}

# TODO uncomment & text.replace_all
            # create_disposition: ${create_disposition}
            # write_disposition: ${write_disposition}
