# Generates an archive file of the source code compressed as a .zip file
data "archive_file" "source_code" {

  type        = "zip"
  source_dir  = "../cloud_functions/cf_trigger_on_file/src"
  output_path = "../cloud_functions/cf_trigger_on_file/tmp/function.zip"

}
# Add source code zip to the cloud function's bucket
resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source_code.output_path
  content_type = "application/zip"

  # Append to the MD5 checksum of the files's content
  # to force the zip to be updated as soon as a change occurs
  name = "src_cf_trigger_on_file.zip"
  # "src-${data.archive_file.source_code.output_path}.zip"
  bucket = google_storage_bucket.cloud_function_sources.name

  # Dependencies are automatically inferred so these lines can be deleted
  #depends_on = [
  # google_storage_bucket.cloud_function_sources, # declared in `cloud_storage.tf`
  # data.archive_file.source_code
  #]
}

# Create the cloud function triggered by a Finalize event on the bucket

