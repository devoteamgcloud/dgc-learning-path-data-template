resource "google_pubsub_topic" "valid_topic" {
  project = var.project_id
  name    = "valid_file"
}