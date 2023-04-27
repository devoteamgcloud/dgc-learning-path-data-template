# Datasets creation
resource "google_bigquery_dataset" "raw" {
  project     = var.project_id
  dataset_id  = "raw"
  description = "A dataset for raw data"
  location    = var.location

}

resource "google_bigquery_dataset" "cleaned" {
  project     = var.project_id
  dataset_id  = "cleaned"
  description = "A dataset for cleaned data"
  location    = var.location

}

resource "google_bigquery_dataset" "staging" {
  project     = var.project_id
  dataset_id  = "staging"
  description = "This is a dataset named staging"
  location    = var.location

}

# Tables creation
resource "google_bigquery_table" "raw_store" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.raw.dataset_id
  table_id            = "store"
  schema              = file("../schemas/raw/store.json")
  deletion_protection = false
}

resource "google_bigquery_table" "cleaned_store" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.cleaned.dataset_id
  table_id            = "store"
  schema              = file("../schemas/cleaned/store.json")
  deletion_protection = false
}

resource "google_bigquery_table" "raw_customer" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.raw.dataset_id
  table_id            = "customer"
  schema              = file("../schemas/raw/customer.json")
  deletion_protection = false
}

resource "google_bigquery_table" "staging_customer" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.staging.dataset_id
  table_id            = "customer"
  schema              = file("../schemas/staging/customer.json")
  deletion_protection = false
}

resource "google_bigquery_table" "cleaned_customer" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.cleaned.dataset_id
  table_id            = "customer"
  schema              = file("../schemas/cleaned/customer.json")
  deletion_protection = false
}