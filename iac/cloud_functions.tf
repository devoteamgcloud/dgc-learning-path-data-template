# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source"{
    type        = "zip"
    source_dir  = "../cloud_functions/cf_trigger_on_file/src"
    output_path = "../cloud_functions/cf_trigger_on_file/src/function.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "zip" {
  source                = data.archive_file.source.output_path
  content_type          = "application/zip"

  # Append to the MD5 checksum of the files's content
  # to force the zip to be updated as soon as a change occurs
  name = "src-${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.cloud_functions_sources.name

  # Dependencies are automatically inferred so these lines can be deleted
  
  depends_on = [ 
    google_storage_bucket.cloud_functions_sources,
    data.archive_file.source
   ]
}


# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "function" {
  name                  = "cf_trigger_onfile"
  runtime               = "python310"


  # Get the source code of the cloud function as a Zip compression
  source_archive_bucket = google_storage_bucket.cloud_functions_sources.name
  source_archive_object = google_storage_bucket_object.zip.name

  # Must match the function name in the cloud function `main.py` source code
  entry_point = "check_file_format"

  event_trigger {
    event_type          = "google.storage.object.finalize"
    resource            = "${var.project_id}-input"
  }

  # Dependencies are automatically inferred so these lines can be deleted
  depends_on = [ 
    google_storage_bucket.cloud_functions_sources,
    google_storage_bucket_object.zip
   ]

}

