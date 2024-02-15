
resource "google_bigquery_dataset" "dataset" {
  count = length(var.dataset_setting)

  dataset_id = count.index
  location   = var.location
}

#resource "google_bigquery_table" "table" {
#  for_each = var.table_setting

#  count      = "${length(each.value)}"
#  dataset_id = "${element(each.value, count.index)}"
#  table_id   = each.key
#  schema     = file("${element(each.value, count.index.schema)}")
#}
#
