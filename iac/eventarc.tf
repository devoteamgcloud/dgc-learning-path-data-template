resource "google_eventarc_trigger" "trigger-on-file" {
    project  = var.project_id
    name = "trigger-on-file"
    location = "europe-west1"
    matching_criteria {
        attribute = "type"
        value = "google.cloud.storage.object.v1.finalized"
    }
    matching_criteria {
        attribute = "bucket"
        value     = google_storage_bucket.magasin_cie_landing2.name
    }
    destination {
        cloud_run_service {
            service = google_cloud_run_service.trigger_on_file.name
            region = "europe-west1"
        }
    }
}