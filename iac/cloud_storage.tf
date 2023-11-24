locals {
  magasin_cie_landing    = "${var.project_id}_magasin_cie_landing"
  magasin_cie_utils      = "${var.project_id}_magasin_cie_utils"
  cloud_function_sources = "${var.project_id}_cloud_function_sources"

  bucket_config = {
    (local.magasin_cie_landing) = {
      project  = var.project_id
      location = var.location
      lifecycle_rules = [
        {
          age                   = 30
          matches_storage_class = ["STANDARD"]
          matches_prefix        = "*/input/"
          action_type           = "SetStorageClass"
          storage_class         = "NEARLINE"
        },
        {
          age                   = 90
          matches_storage_class = ["NEARLINE"]
          matches_prefix        = "*/input/"
          action_type           = "SetStorageClass"
          storage_class         = "COLDLINE"
        },
        {
          age                   = 365
          matches_storage_class = ["COLDLINE"]
          matches_prefix        = "*/input/"
          action_type           = "SetStorageClass"
          storage_class         = "ARCHIVE"
        },
        {
          age                   = 1000
          matches_storage_class = ["ARCHIVE"]
          matches_prefix        = "*/input/"
          action_type           = "Delete"
      }]
    }
    (local.magasin_cie_utils) = {
      project  = var.project_id,
      location = var.location
    }
    (local.cloud_function_sources) = {
      project                     = var.project_id
      name                        = "${var.project_id}_cloud_functions_sources"
      location                    = var.location
      force_destroy               = true
      uniform_bucket_level_access = true
    }
  }

  bucket_object_config = {
    "input" = {
      bucket  = local.magasin_cie_landing
      content = " "
    }

    "invalid" = {
      bucket  = local.magasin_cie_landing
      content = " "
    }
  }
}

resource "google_storage_bucket" "buckets" {
  for_each = local.bucket_config
  #Required
  name     = each.key
  project  = each.value.project
  location = each.value.location

  #Optional, hence the clause 'try(attribute, if not exists)'
  force_destroy               = try(each.value.force_destroy, false)
  uniform_bucket_level_access = try(each.value.uniform_bucket_level_access, false)
  dynamic "lifecycle_rule" {
    for_each = try(each.value.lifecycle_rules, [])
    content {
      #I think it could be possible to just use the 'try' clause with 'storage_class' since it is the only one which does not exist in all lifecycle_rule
      condition {
        age                   = try(lifecycle_rule.value.age, null)
        matches_storage_class = try(lifecycle_rule.value.matches_storage_class, null)
      }
      action {
        type          = try(lifecycle_rule.value.action_type, null)
        storage_class = try(lifecycle_rule.value.storage_class, null)
      }
    }
  }
}

resource "google_storage_bucket_object" "objects" {
  for_each = local.bucket_object_config
  name     = each.key
  content  = try(each.value.content, null)
  source   = try(each.value.source, null)
  bucket   = each.value.bucket
}

resource "google_storage_bucket_object" "queries" {
  bucket   = local.magasin_cie_utils
  for_each = fileset("../queries", "**")
  name     = each.value
  source   = "../queries/${each.value}"
}

resource "google_storage_bucket_object" "schemas" {
  bucket   = local.magasin_cie_utils
  for_each = fileset("../schemas", "**")
  name     = each.value
  source   = "../schemas/${each.value}"
}