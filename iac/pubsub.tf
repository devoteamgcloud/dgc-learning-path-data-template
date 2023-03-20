resource "google_pubsub_topic" "topic_vaild_file" {
  project = var.project_id
  name    = "valid_file"
}