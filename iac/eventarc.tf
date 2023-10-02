resource "google_eventarc_trigger" "trigger_on_file_event" {
    project  = var.project_id
    name = "trigger-on-file-event"
    location = "eu"
    service_account = "eventarc-cloudrun-learning-pat@sandbox-vcordonnier.iam.gserviceaccount.com"
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