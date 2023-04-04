resource "google_pubsub_topic" "topic_validation" {
  name = "valid_file"
  project = var.project_id
}