resource "google_bigquery_dataset" "datasets" {
  for_each    = local.dataset_config
  dataset_id  = each.value.dataset_id
  description = each.value.description
}

resource "google_bigquery_table" "tables" {
  for_each   = local.tables_config
  dataset_id = each.value.dataset_id
  table_id   = each.value.table_id
  schema     = each.value.schema
}