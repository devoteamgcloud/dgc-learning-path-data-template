resource "google_storage_bucket" "magasin_cie_landing" {
  project  = var.project_id
  name     = "${var.project_id}_magasin_cie_landing"
  location = var.location
  force_destroy = true
  lifecycle_rule {
    condition {
      age = 30
      matches_prefix = [ "archive" ]
    }
    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  lifecycle_rule {
    condition {
      age = 90
      matches_prefix = [ "archive" ]
    }
    action {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
  lifecycle_rule {
    condition {
      age = 365
      matches_prefix = [ "archive" ]
    }
    action {
      type = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }
  lifecycle_rule {
    condition {
      age = 1000
      matches_prefix = [ "archive" ]
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
  force_destroy = true
}

resource "google_storage_bucket" "cloud_functions_sources" {
  project                     = var.project_id
  name                        = "${var.project_id}_cloud_functions_sources"
  location                    = var.location
  force_destroy               = true
  uniform_bucket_level_access = true
}

locals {
  files = fileset("${path.module}/../","{queries,schemas}/**")
}
resource "google_storage_bucket_object" "queries_schemas" {
for_each = local.files
  name   = each.value
  source = "../${each.value}"
  bucket = google_storage_bucket.magasin_cie_utils.name
}