### BUCKETS ###

resource "google_storage_bucket" "buckets" {
  for_each = local.bucket_config
  #### Required args ###
  name     = each.key
  project  = each.value.project
  location = each.value.location
  ### Optional args ###
  force_destroy               = try(each.value.force_destroy, false)
  uniform_bucket_level_access = try(each.value.uniform_bucket_level_access, false)
  dynamic "lifecycle_rule" {
    for_each = try(each.value.lifecycle_rules, [])
    content {
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

### GCS BUCKET OBJECTS ###

### Files ('/input' and "/invalid") ###
resource "google_storage_bucket_object" "files" {
  for_each = local.bucket_object_config
  name     = each.key
  content  = try(each.value.content, null)
  source   = try(each.value.source, null)
  bucket   = each.value.bucket
}

### Queries ###
resource "google_storage_bucket_object" "queries" {
  bucket   = local.magasin_cie_utils
  for_each = fileset("../queries", "**")
  name     = each.value
  source   = "../queries/${each.value}"
}

### Schemas ###
resource "google_storage_bucket_object" "schemas" {
  bucket   = local.magasin_cie_utils
  for_each = fileset("../schemas", "**")
  name     = each.value
  source   = "../schemas/${each.value}"
}