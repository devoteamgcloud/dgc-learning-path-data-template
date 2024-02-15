
resource "google_bigquery_dataset" "dataset" {
  for_each = toset(var.bq_datasets)

  dataset_id = each.value
  location   = var.location
}

resource "google_bigquery_table" "table" {
  for_each   = { for t in var.bq_tables : t.name => t }
  dataset_id = each.value.datasets.dataset_id
  table_id   = each.value.tables_name
  #schema = 
}

#resource "google_bigquery_table" "table" {
#  for_each = var.table_setting

#  count      = "${length(each.value)}"
#  dataset_id = "${element(each.value, count.index)}"
#  table_id   = each.key
#  schema     = file("${element(each.value, count.index.schema)}")
#}
#
