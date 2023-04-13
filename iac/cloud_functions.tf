data "archive_file" "source" {
    type    = "zip"
    source_dir  = "../cloud_functions/cf_trigger_on_file/src"
    output_path = "./tmp/check_file_format.zip"
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
    name                  = "check-file-format-trigger-on-gcs"
    runtime               = "python310"  # of course changeable
    project               = var.project_id
    region                = var.region

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
        resource   = "${var.project_id}_magasin-cie-landing"
    }

    environment_variables = yamldecode(file("../cloud_functions/cf_trigger_on_file/env.yaml"))

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

  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}



data "archive_file" "receive_msg_source" {
    type         = "zip"
    source_dir   = "../cloud_functions/cf_dispatch_workflow/src"
    output_path  = "./tmp/receive_messages.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "receive_messages_zip" {
    source       = data.archive_file.receive_msg_source.output_path
    content_type = "application/zip"

    # Append to the MD5 checksum of the files's content
    # to force the zip to be updated as soon as a change occurs
    name         = "src-${data.archive_file.receive_msg_source.output_md5}.zip"
    bucket       = google_storage_bucket.cloud_functions_sources.name

    # Dependencies are automatically inferred so these lines can be deleted
    depends_on   = [
        google_storage_bucket.cloud_functions_sources,  # declared in `storage.tf`
        data.archive_file.receive_msg_source
    ]
}

# Create the Cloud function triggered by a `Publish` event on the valid_file topic
resource "google_cloudfunctions_function" "cloud_functions_sources_receive_msg" {
    name                  = "receive-msg-trigger-on-gcs"
    runtime               = "python310"  # of course changeable
    project               = var.project_id
    region                = var.region

    # Get the source code of the cloud function as a Zip compression
    available_memory_mb   = 256
    source_archive_bucket = google_storage_bucket.cloud_functions_sources.name
    source_archive_object = google_storage_bucket_object.receive_messages_zip.name
    # trigger_http          = true

    # Must match the function name in the cloud function `main.py` source code
    entry_point           = "receive_messages"
    
    # 
    event_trigger {
        event_type        = "google.pubsub.topic.publish"
        resource          = "projects/${var.project_id}/topics/valid_file"
    }

    environment_variables = yamldecode(file("../cloud_functions/cf_dispatch_workflow/env.yaml"))

    # Dependencies are automatically inferred so these lines can be deleted
    depends_on            = [
        google_storage_bucket.cloud_functions_sources,  # declared in `storage.tf`
        google_storage_bucket_object.receive_messages_zip
    ]
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "receive_message_invoker" {
  project        = google_cloudfunctions_function.cloud_functions_sources_receive_msg.project
  region         = google_cloudfunctions_function.cloud_functions_sources_receive_msg.region
  cloud_function = google_cloudfunctions_function.cloud_functions_sources_receive_msg.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}