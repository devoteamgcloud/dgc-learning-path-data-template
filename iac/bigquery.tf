locals {
  bq_datasets_setting = {
    "raw" = [
      {
        tables_name = "store",
        schema      = "../schemas/raw/store.json"
      }
    ],
    "cleaned" = [
      {
        tables_name = "store",
        schema      = "../schemas/cleaned/store.json"
      }
    ]
  }
}

resource "google_bigquery_dataset" "dataset" {
  for_each = locals.bq_datasets_setting
  #toset(var.bq_datasets)

  dataset_id = each.key
  location   = var.location
}

resource "google_bigquery_table" "table" {
  for_each = locals.bq_datasets_setting
  #{ for t in var.bq_tables, d in t.datasets : "${t.name}-${d.name}"=> d }
  dataset_id = each.key
  dynamic "tables" {
    for_each = toset(each.value)
  }
  table_id = tables.value.tables_name
  schema   = file("${tables.value.schema}")
}

#resource "google_bigquery_table" "table" {
#  for_each = var.table_setting

#  count      = "${length(each.value)}"
#  dataset_id = "${element(each.value, count.index)}"
#  table_id   = each.key
#  schema     = file("${element(each.value, count.index.schema)}")
#}
#
