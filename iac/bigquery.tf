resource "google_bigquery_dataset" "raw" {
    dataset_id = "raw"
    project = var.project_id
    description = "This is the raw table for Magasin&Cie"
    location = "EU"
}

resource "google_bigquery_dataset" "cleaned" {
    dataset_id = "cleaned"
    project = var.project_id
    description = "This is the cleaned table for Magasin&Cie"
    location = "EU"
}

resource "google_bigquery_dataset" "staging" {
    dataset_id = "staging"
    project = var.project_id
    description = "This is the staging table for Magasin&Cie"
    location = "EU"
}

resource "google_bigquery_table" "store_raw" {
  dataset_id = google_bigquery_dataset.raw.dataset_id
  table_id   = "store"
  project = var.project_id
}

resource "google_bigquery_table" "store_cleaned" {
  dataset_id = google_bigquery_dataset.cleaned.dataset_id
  table_id   = "store"
  project = var.project_id
}

resource "google_bigquery_table" "customer_raw" {
  dataset_id = google_bigquery_dataset.raw.dataset_id
  table_id   = "customer"
  project = var.project_id
}

resource "google_bigquery_table" "customer_staging" {
  dataset_id = google_bigquery_dataset.staging.dataset_id
  table_id   = "customer"
  project = var.project_id
}

resource "google_bigquery_table" "customer_cleaned" {
  dataset_id = google_bigquery_dataset.cleaned.dataset_id
  table_id   = "customer"
  project = var.project_id
}