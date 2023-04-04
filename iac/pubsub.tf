resource "google_pubsub_topic" "topic_valid" {
  project = var.project_id
  name    = "valid_file"
}
