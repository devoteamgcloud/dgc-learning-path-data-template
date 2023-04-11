data "archive_file" "source" {
    type    = "zip"
    source_dir  = "../cloud_functions/cf_trigger_on_file/src"
    output_path = "./tmp/function.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "zip" {
    source       = data.archive_file.source.output_path
    content_type = "application/zip"

    # Append to the MD5 checksum of the files's content
    # to force the zip to be updated as soon as a change occurs
    name         = "src-${data.archive_file.source.output_md5}.zip"
    bucket       = google_storage_bucket.cloud_functions_sources.name

    # Dependencies are automatically inferred so these lines can be deleted
    depends_on   = [
        google_storage_bucket.cloud_functions_sources,  # declared in `storage.tf`
        data.archive_file.source
    ]
}

# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "cloud_functions_sources" {
    name                  = "function-trigger-on-gcs"
    runtime               = "python310"  # of course changeable
    project = var.project_id
    region = "europe-west1"

    # Get the source code of the cloud function as a Zip compression
    available_memory_mb   = 128
    source_archive_bucket = google_storage_bucket.cloud_functions_sources.name
    source_archive_object = google_storage_bucket_object.zip.name
    # trigger_http          = true

    # Must match the function name in the cloud function `main.py` source code
    entry_point           = "check_file_format"
    
    # 
    event_trigger {
        event_type = "google.storage.object.finalize"
        resource   = "${var.project_id}_magasin_cie_landing"
    }

    # Dependencies are automatically inferred so these lines can be deleted
    depends_on            = [
        google_storage_bucket.cloud_functions_sources,  # declared in `storage.tf`
        google_storage_bucket_object.zip
    ]
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.cloud_functions_sources.project
  region         = google_cloudfunctions_function.cloud_functions_sources.region
  cloud_function = google_cloudfunctions_function.cloud_functions_sources.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}