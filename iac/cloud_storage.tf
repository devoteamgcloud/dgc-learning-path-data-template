resource "google_storage_bucket" "magasin_cie_landing" {
  project  = var.project_id
  name     = "${var.project_id}_magasin-cie-landing"
  location = var.location
  force_destroy = true
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
  lifecycle_rule {
    condition {
      age = 365
      matches_prefix = ["archive/ARCHIVE"]
    }
    action {
      type = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }
  lifecycle_rule {
    condition {
      age = 1000
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket" "magasin_cie_utils" {
  project  = var.project_id
  name     = "${var.project_id}_magasin-cie-utils"
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

