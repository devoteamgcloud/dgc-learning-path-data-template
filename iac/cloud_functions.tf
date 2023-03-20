# Generates an archive of the source code compressed as a .zip file.

data "archive_file" "source_cf_trigger_on_file" {
    type        = "zip"
    source_dir  = "../cloud_functions/cf_trigger_on_file/src"
    output_path = "tmp/function_tof.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "zip_cf_trigger_on_file" {
    source       = data.archive_file.source_cf_trigger_on_file.output_path
    content_type = "application/zip"

    # Append to the MD5 checksum of the files's content
    # to force the zip to be updated as soon as a change occurs
    name         = "src-${data.archive_file.source_cf_trigger_on_file.output_md5}.zip"
    bucket       = google_storage_bucket.cloud_functions_sources.name
}

# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "function_trigger_on_file" {
    name                  = "cf_trigger_on_file"
    project = var.project_id
    region = var.region
    runtime               = "python311"  # of course changeable

    # Get the source code of the cloud function as a Zip compression
    source_archive_bucket = google_storage_bucket.cloud_functions_sources.name
    source_archive_object = google_storage_bucket_object.zip_cf_trigger_on_file.name

    # Must match the function name in the cloud function `main.py` source code
    entry_point           = "check_file_format"
    
    # 
    event_trigger {
        event_type = "google.storage.object.finalize"
        resource   = "${var.project_id}_magasin_cie_landing"
    }
}

data "archive_file" "source_cf_dispatch_workflow" {
    type        = "zip"
    source_dir  = "../cloud_functions/cf_dispatch_workflow/src"
    output_path = "tmp/function_wkf.zip"
}

resource "google_storage_bucket_object" "zip_cf_dispatch_workflow" {
    source       = data.archive_file.source_cf_dispatch_workflow.output_path
    content_type = "application/zip"

    # Append to the MD5 checksum of the files's content
    # to force the zip to be updated as soon as a change occurs
    name         = "src-${data.archive_file.source_cf_dispatch_workflow.output_md5}.zip"
    bucket       = google_storage_bucket.cloud_functions_sources.name
}

resource "google_cloudfunctions_function" "function_dispatch_workflow" {
    name                  = "cf_dispatch_workflow"
    project = var.project_id
    region = var.region
    runtime = "python311"  # of course changeable

    # Get the source code of the cloud function as a Zip compression
    source_archive_bucket = google_storage_bucket.cloud_functions_sources.name
    source_archive_object = google_storage_bucket_object.zip_cf_dispatch_workflow.name

    # Must match the function name in the cloud function `main.py` source code
    entry_point           = "receive_messages"
    
    # 
    event_trigger {
        event_type = "google.cloud.pubsub.topic.v1.messagePublished"
        pubsub_topic   = google_pubsub_topic.topic_vaild_file.name
    }
}