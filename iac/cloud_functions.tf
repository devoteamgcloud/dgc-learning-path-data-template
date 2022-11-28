data "archive_file" "source" {
    type        = "zip"
    source_dir  = "../cloud_functions/cf_trigger_on_file/src"
    output_path = "tmp/function.zip"
}

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

resource "google_cloudfunctions_function" "function" {
    project  = var.project_id
    region = var.region
    name                  = "function-trigger-on-gcs"
    runtime               = "python37"  # of course changeable

    # Get the source code of the cloud function as a Zip compression
    source_archive_bucket = google_storage_bucket.cloud_functions_sources.name
    source_archive_object = google_storage_bucket_object.zip.name

    # Must match the function name in the cloud function `main.py` source code
    entry_point           = "check_file_format"
    
    # 
    event_trigger {
        event_type = "google.storage.object.finalize"
        resource   = "${var.project_id}_magasins_cie_landing"
    }

    # Dependencies are automatically inferred so these lines can be deleted
    depends_on            = [
        google_storage_bucket.cloud_functions_sources,  # declared in `storage.tf`
        google_storage_bucket_object.zip
    ]
}