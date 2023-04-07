# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "archive_trigger" {
  type        = "zip"
  source_dir  = "../cloud_functions/cf_trigger_on_file/src"
  output_path = "tmp/trigger.zip"
}

# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "archive_workflow" {
  type        = "zip"
  source_dir  = "../cloud_functions/cf_dispatch_workflow/src"
  output_path = "tmp/workflow.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "zip" {
    source       = data.archive_file.archive_trigger.output_path
    content_type = "application/zip"

    # Append to the MD5 checksum of the files's content
    # to force the zip to be updated as soon as a change occurs
    name         = "src-${data.archive_file.archive_trigger.output_md5}.zip"
    bucket       = google_storage_bucket.cloud_functions_sources.name

    # Dependencies are automatically inferred so these lines can be deleted
    depends_on   = [
        google_storage_bucket.cloud_functions_sources,  # declared in `cloud_storage.tf`
        data.archive_file.archive_trigger
    ]
}

resource "google_storage_bucket_object" "zip2" {
    source       = data.archive_file.archive_workflow.output_path
    content_type = "application/zip"

    # Append to the MD5 checksum of the files's content
    # to force the zip to be updated as soon as a change occurs
    name         = "src-${data.archive_file.archive_workflow.output_md5}.zip"
    bucket       = google_storage_bucket.cloud_functions_sources.name

    # Dependencies are automatically inferred so these lines can be deleted
    depends_on   = [
        google_storage_bucket.cloud_functions_sources,  # declared in `cloud_storage.tf`
        data.archive_file.archive_workflow
    ]
}

resource "google_cloudfunctions_function" "trigger" {
    project               = var.project_id
    region                = var.region
    name                  = "trigger_on_file"
    runtime               = "python310"  # of course changeable
    environment_variables = yamldecode(file("../cloud_functions/cf_trigger_on_file/env.yaml"))

    # Must match the function name in the cloud function `main.py` source code
    entry_point           = "check_file_format"
    
   # Get the source code of the cloud function as a Zip compression
    source_archive_bucket = google_storage_bucket.cloud_functions_sources.name
    source_archive_object = google_storage_bucket_object.zip.name

    event_trigger {
        event_type = "google.storage.object.finalize"
        resource   = "${var.project_id}_magasin_cie_landing"
    }

    # Dependencies are automatically inferred so these lines can be deleted
    depends_on            = [
        google_storage_bucket.cloud_functions_sources,  # declared in `cloud_storage.tf`
        google_storage_bucket_object.zip
    ]
}

resource "google_cloudfunctions_function" "workflows" {
    project               = var.project_id
    region                = var.region
    name                  = "dispatch_workflow"
    runtime               = "python310"  # of course changeable
    environment_variables = yamldecode(file("../cloud_functions/cf_dispatch_workflow/env.yaml"))

    # Must match the function name in the cloud function `main.py` source code
    entry_point           = "receive_messages"
    
   # Get the source code of the cloud function as a Zip compression
    source_archive_bucket = google_storage_bucket.cloud_functions_sources.name
    source_archive_object = google_storage_bucket_object.zip2.name

    event_trigger {
        event_type = "google.storage.object.finalize"
        resource   = "${var.project_id}_magasin_cie_landing"
    }

    # Dependencies are automatically inferred so these lines can be deleted
    depends_on            = [
        google_storage_bucket.cloud_functions_sources,  # declared in `cloud_storage.tf`
        google_storage_bucket_object.zip2
    ]
}