resource "google_bigquery_dataset" "raw" {
  dataset_id                  = "raw"
  friendly_name               = "raw"
  description                 = "This is a RAW dataset"
  location                    = "EU"
}

resource "google_bigquery_dataset" "cleaned" {
  dataset_id                  = "cleaned"
  friendly_name               = "cleaned"
  description                 = "This is a cleaned dataset"
  location                    = "EU"
}

resource "google_bigquery_table" "store" {
  dataset_id = google_bigquery_dataset.raw.raw
  table_id = "store"
  schema = file("schemas/raw/store.json")
}

resource "google_bigquery_table" "store" {
  dataset_id = google_bigquery_dataset.cleaned.cleaned
  table_id = "store"
  schema = file("schemas/cleaned/store.json")
}