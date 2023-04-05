resource "google_cloudfunctions_function" "trigger" {
  name        = "trigger_on_file"
  description = "function that checks the file format and assign them to different folders"
  runtime     = "python310"
  region      = "europe-west1"
  entry_point = "check_file_format"
}