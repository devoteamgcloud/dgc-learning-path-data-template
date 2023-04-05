resource "google_cloudfunctions_function" "trigger" {
  name        = "trigger_on_file"
  project     = var.project_id
  description = "function that checks the file format and assign them to different folders"
  runtime     = "python310"
  region      = var.region
  entry_point = "check_file_format"
}