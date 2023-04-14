resource "google_pubsub_topic" "valid_file" {
  project = var.project_id
  name = "valid_file"
}