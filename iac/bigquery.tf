#DATASETS 
resource "google_bigquery_dataset" "raw" {
  dataset_id                  = var.raw
  description                 = "raw dataset"
  location                    = "EU"
}

resource "google_bigquery_dataset" "cleaned" {
  dataset_id                  = var.cleaned
  description                 = "cleaned dataset"
  location                    = "EU"
}

# TABLES

resource "google_bigquery_table" "store_raw" {
  dataset_id = var.raw
  table_id = var.store
  schema = "schemas/raw/store.json"
}
resource "google_bigquery_table" "store_cleaned" {
  dataset_id = var.cleaned
  table_id = var.store
  schema = "schemas/cleaned/store.json"
}
