resource "google_pubsub_topic" "valid_file_pubsub" {
    name                = "valid_file"
    project             = var.project_id
}