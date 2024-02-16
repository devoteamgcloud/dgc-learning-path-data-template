
resource "google_bigquery_dataset" "dataset" {
  for_each = var.bq_datasets_setting
  #toset(var.bq_datasets)

  dataset_id = each.key
  location   = var.location
}

resource "google_bigquery_table" "table" {
  for_each = var.bq_datasets_setting

  dataset_id = each.key

  table_id = each.value.tables_name
  schema   = file("${each.value.schema}")
}

#resource "google_bigquery_table" "table" {
#  for_each = var.table_setting

#  count      = "${length(each.value)}"
#  dataset_id = "${element(each.value, count.index)}"
#  table_id   = each.key
#  schema     = file("${element(each.value, count.index.schema)}")
#}
#
