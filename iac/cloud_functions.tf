# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source_trigger_on_file" {  # [MENTOR #3]
  type        = "zip"
  source_dir  = "../cloud_functions/cf_trigger_on_file/src"
  output_path = "tmp/function_trigger_on_file.zip"
}

data "archive_file" "source_dispatch_workflow" {
  type        = "zip"
  source_dir  = "../cloud_functions/cf_dispatch_workflow/src"
  output_path = "tmp/function_dispatch_workflow.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "zip_trigger_on_file" {  # [MENTOR #3]
  source       = data.archive_file.source_trigger_on_file.output_path
  content_type = "application/zip"

  # Append to the MD5 checksum of the files's content
  # to force the zip to be updated as soon as a change occurs
  name   = "src-${data.archive_file.source_trigger_on_file.output_md5}.zip"
  bucket = google_storage_bucket.cloud_functions_sources.name

  # Dependencies are automatically inferred so these lines can be deleted
  depends_on = [
    google_storage_bucket.cloud_functions_sources, # declared in `storage.tf`
    data.archive_file.source_trigger_on_file
  ]
}

resource "google_storage_bucket_object" "zip_dispatch_workflow" {
  source       = data.archive_file.source_dispatch_workflow.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.source_dispatch_workflow.output_md5}.zip"
  bucket       = google_storage_bucket.cloud_functions_sources.name

  depends_on = [
    google_storage_bucket.cloud_functions_sources,
    data.archive_file.source_dispatch_workflow
  ]
}

# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "function_source_trigger_on_file" {  # [MENTOR #3]
  project               = var.project_id
  region                = var.region
  name                  = "function-trigger-on-gcs"
  runtime               = "python37" # of course changeable
  environment_variables = yamldecode(file("../cloud_functions/cf_trigger_on_file/env.yaml"))

  # Get the source code of the cloud function as a Zip compression
  source_archive_bucket = google_storage_bucket.cloud_functions_sources.name
  source_archive_object = google_storage_bucket_object.zip_trigger_on_file.name

  # Must match the function name in the cloud function `main.py` source code
  entry_point = "check_file_format"

  # 
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = "${var.project_id}_magasin_cie_landing"
  }

  # Dependencies are automatically inferred so these lines can be deleted
  depends_on = [
    google_storage_bucket.cloud_functions_sources, # declared in `storage.tf`
    google_storage_bucket_object.zip_trigger_on_file
  ]
}

resource "google_cloudfunctions_function" "function_dispatch_workflow" {
  project               = var.project_id
  region                = var.region
  name                  = "function-dispatch-workflow-on-gcs"
  runtime               = "python37"
  environment_variables = yamldecode(file("../cloud_functions/cf_dispatch_workflow/env.yaml"))

  source_archive_bucket = google_storage_bucket.cloud_functions_sources.name
  source_archive_object = google_storage_bucket_object.zip_dispatch_workflow.name

  entry_point = "receive_messages"

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.topic_valid.name
  }

  # Dependencies are automatically inferred so these lines can be deleted
  depends_on = [
    google_storage_bucket.cloud_functions_sources, # declared in `storage.tf`
    google_storage_bucket_object.zip_dispatch_workflow
  ]
}
