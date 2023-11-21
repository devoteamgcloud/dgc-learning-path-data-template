# #Configuration of 'magasin_cie_landing' bucket

# resource "google_storage_bucket" "magasin_cie_landing" {
#   project  = var.project_id
#   name     = "${var.project_id}-magasin-cie-landing"
#   location = var.location

#   lifecycle_rule {
#     condition {
#       age                   = 30
#       matches_storage_class = ["STANDARD"]
#     }
#     action {
#       type          = "SetStorageClass"
#       storage_class = "NEARLINE"
#     }
#   }

#   lifecycle_rule {
#     condition {
#       age                   = 90
#       matches_storage_class = ["NEARLINE"]
#     }
#     action {
#       type          = "SetStorageClass"
#       storage_class = "COLDLINE"
#     }
#   }

#   lifecycle_rule {
#     condition {
#       age                   = 365
#       matches_storage_class = ["COLDLINE"]
#     }
#     action {
#       type          = "SetStorageClass"
#       storage_class = "ARCHIVE"
#     }
#   }

#   lifecycle_rule {
#     condition {
#       age                   = 1000
#       matches_storage_class = ["ARCHIVE"]
#     }
#     action {
#       type = "Delete"
#     }
#   }
# }

# resource "google_storage_bucket_object" "input" {
#   name    = "input"
#   content = " "
#   bucket  = google_storage_bucket.magasin_cie_landing.name
# }

# resource "google_storage_bucket_object" "invalid" {
#   name    = "invalid"
#   content = " "
#   bucket  = google_storage_bucket.magasin_cie_landing.name
# }

# #Configuration of 'magasin_cie_utils' bucket
# resource "google_storage_bucket" "magasin_cie_utils" {
#   project  = var.project_id
#   name     = "${var.project_id}_magasin_cie_utils"
#   location = var.location
# }

# #Configuration of 'cloud_functions_sources' bucket
# resource "google_storage_bucket" "cloud_functions_sources" {
#   project                     = var.project_id
#   name                        = "${var.project_id}_cloud_functions_sources"
#   location                    = var.location
#   force_destroy               = true
#   uniform_bucket_level_access = true
# }