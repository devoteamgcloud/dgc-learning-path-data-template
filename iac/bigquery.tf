resource "google_bigquery_dataset" "raw" {
  dataset_id                  = "raw"
  friendly_name               = "raw"
  description                 = "This is a RAW dataset"
  location                    = var.location
}

resource "google_bigquery_dataset" "cleaned" {
  dataset_id                  = "cleaned"
  friendly_name               = "cleaned"
  description                 = "This is a cleaned dataset"
  location                    = var.location
}

resource "google_bigquery_table" "raw_store" {
  dataset_id = var.raw
  table_id = var.raw_store
  schema = file("../schemas/raw/store.json")
}

resource "google_bigquery_table" "cleaned_store" {
  dataset_id = var.cleaned
  table_id = var.cleaned_store
  schema = file("../schemas/cleaned/store.json")
}