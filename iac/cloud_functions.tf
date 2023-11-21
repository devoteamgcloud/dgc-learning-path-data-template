# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../cloud_functions/cf_trigger_on_file/src"
  output_path = "/tmp/check_file_format.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"

  # Append to the MD5 checksum of the files's content
  # to force the zip to be updated as soon as a change occurs
  name   = "src-${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.buckets[local.cloud_function_sources].name
}

# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "check_file_format" {
  name    = "check_file_format"
  runtime = "python39"

  # Get the source code of the cloud function as a Zip compression
  source_archive_bucket = google_storage_bucket.buckets[local.cloud_function_sources].name
  source_archive_object = google_storage_bucket_object.zip.name

  # Must match the function name in the cloud function `main.py` source code
  entry_point = "check_file_format"

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = "projects/${var.project_id}/buckets/${var.project_id}_magasin_cie_landing"
  }
}