resource "google_bigquery_dataset" "dataset_raw" {
  project = var.project_id
  dataset_id                  = "raw"
  description                 = "This is the raw dataset"
  location                    = "EU"
}
resource "google_bigquery_dataset" "dataset_staging" {
  project = var.project_id
  dataset_id                  = "staging"
  description                 = "This is the staging dataset"
  location                    = "EU"
}
resource "google_bigquery_dataset" "dataset_cleaned" {
  project = var.project_id
  dataset_id                  = "cleaned"
  description                 = "This is the cleaned dataset"
  location                    = "EU"
}

resource "google_bigquery_table" "table_store_raw" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_raw.dataset_id
  table_id   = "store"
  schema =file("../schemas/raw/store.json") 
  deletion_protection = false
}

resource "google_bigquery_table" "table_store_cleaned" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_cleaned.dataset_id
  table_id   = "store"
  schema =file("../schemas/cleaned/store.json")
  deletion_protection = false
}

resource "google_bigquery_table" "table_customer_raw" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_raw.dataset_id
  table_id   = "customer"
  schema =file("../schemas/raw/customer.json") 
  deletion_protection = false
}

resource "google_bigquery_table" "table_customer_staging" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_staging.dataset_id
  table_id   = "customer"
  schema =file("../schemas/staging/customer.json") 
  deletion_protection = false
}

resource "google_bigquery_table" "table_customer_cleaned" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_cleaned.dataset_id
  table_id   = "customer"
  schema =file("../schemas/cleaned/customer.json")
  deletion_protection = false
}