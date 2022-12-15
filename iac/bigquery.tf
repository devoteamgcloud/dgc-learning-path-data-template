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
  project = var.project_id
  dataset_id = "staging"
  description = "A dataset for staging data"
  location =  var.location
}

resource "google_bigquery_table" "raw_store" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.raw.dataset_id
  table_id            = "store"
  schema              = file("../schemas/raw/store.json")
}

resource "google_bigquery_table" "raw_customer" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.raw.dataset_id
  table_id = "customer"
  schema = file("../schemas/raw/customer.json")
}

resource "google_bigquery_table" "staging_customer" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.staging.dataset_id
  table_id = "customer"
  schema = file("../schemas/staging/customer.json")
}
resource "google_bigquery_table" "cleaned_store" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.cleaned.dataset_id
  table_id            = "store"
  schema              = file("../schemas/cleaned/store.json")
}

resource "google_bigquery_table" "cleaned_customer" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.cleaned.dataset_id
  table_id            = "customer"
  schema              = file("../schemas/cleaned/customer.json")
}

