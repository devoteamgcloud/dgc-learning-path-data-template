
locals {
  bq_utils_folders = {
    queries = {
      source_dir  = "../queries",
      output_path = "../queries.zip"
    },
    schemas = {
      source_dir  = "../schemas",
      output_path = "../schemas.zip"
    }
  }
}

data "archive_file" "bq_utils_folders_zip" {

  for_each = local.bq_utils_folders

  type        = "zip"
  source_dir  = each.value.source_dir  #"../queries"
  output_path = each.value.output_path #"../queries.zip"

}


resource "google_storage_bucket" "magasin_cie_landing" {
  project  = var.project_id
  name     = "${var.project_id}_magasin_cie_landing"
  location = var.location
  lifecycle_rule {
    condition {
      age            = 30
      matches_prefix = ["archive/"]
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  lifecycle_rule {
    condition {
      age            = 90
      matches_prefix = ["archive/"]
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
  lifecycle_rule {
    condition {
      age            = 365
      matches_prefix = ["archive/"]
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }
  lifecycle_rule {
    condition {
      age            = 1825
      matches_prefix = ["archive/"]
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket" "magasin_cie_utils" {
  project  = var.project_id
  name     = "${var.project_id}_magasin_cie_utils"
  location = var.location
}

resource "google_storage_bucket" "cloud_function_sources" {
  project                     = var.project_id
  name                        = "${var.project_id}_cloud_function_source"
  location                    = var.location
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "folders" {

  for_each = local.bq_utils_folders

  name         = each.key               #each.key
  source       = each.value.output_path #data.archive_file.queries_folder.output_path #each.value.source_dir
  content_type = "application/zip"
  bucket       = google_storage_bucket.magasin_cie_utils.name

  depends_on = [
    # google_storage_bucket.cloud_function_sources, # declared in `cloud_storage.tf`
    data.archive_file.bq_utils_folders_zip
  ]
}


# resource "google_storage_bucket" "cloud_functions_sources" {
#   project                     = var.project_id
#   name                        = "${var.project_id}_cloud_functions_sources"
#   location                    = var.location
#   force_destroy               = true
#   uniform_bucket_level_access = true
# }

