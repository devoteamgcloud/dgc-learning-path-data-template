resource "google_bigquery_dataset" "dataset" {
  for_each = {
    "raw"     = "Dataset for raw data",
    "cleaned" = "Dataset for clean data"
  }
  dataset_id  = each.key
  description = each.value
  location    = var.location
}

resource "google_bigquery_table" "table" {
  for_each = {
    "store" = { dataset_id = "raw", schema = "../schemas/raw/store.json" },
    "store" = { dataset_id = "cleaned", schema = "../schemas/cleaned/store.json" }
  }
  dataset_id = each.value.dataset_id
  table_id   = each.key
  schema     = file("${each.value.schema}")

}
