### Datasets creation ###
# Create dataset raw
resource "google_bigquery_dataset" "raw" {
  project  = var.project_id
  dataset_id                  = "raw"
  friendly_name               = "test"
  description                 = "This is the dataset named raw"
  location                    = "EU"
}

# Create dataset cleaned
resource "google_bigquery_dataset" "cleaned" {
  project  = var.project_id
  dataset_id                  = "cleaned"
  friendly_name               = "test"
  description                 = "This is a dataset named cleaned"
  location                    = "EU"

}

# Create dataset staging
resource "google_bigquery_dataset" "staging" {
  project  = var.project_id
  dataset_id                  = "staging"
  friendly_name               = "test"
  description                 = "This is a dataset named staging"
  location                    = "EU"

}

### Tbales creation ###
# Store tables
resource "google_bigquery_table" "raw_store" {
  project  = var.project_id
  dataset_id = google_bigquery_dataset.raw.dataset_id
  table_id   = "store"
  schema = file("../schemas/raw/store.json")
  deletion_protection = false
}

resource "google_bigquery_table" "cleaned_store" {
  project  = var.project_id
  dataset_id = google_bigquery_dataset.cleaned.dataset_id
  table_id   = "store"
  schema = file("../schemas/cleaned/store.json")
  deletion_protection = false
}

# Customer tables
resource "google_bigquery_table" "raw_customer" {
  project  = var.project_id
  dataset_id = google_bigquery_dataset.raw.dataset_id
  table_id   = "customer"
  schema = file("../schemas/raw/customer.json")
  deletion_protection = false
}

resource "google_bigquery_table" "staging_customer" {
  project  = var.project_id
  dataset_id = google_bigquery_dataset.staging.dataset_id
  table_id   = "customer"
  schema = file("../schemas/staging/customer.json")
  deletion_protection = false
}

resource "google_bigquery_table" "cleaned_customer" {
  project  = var.project_id
  dataset_id = google_bigquery_dataset.cleaned.dataset_id
  table_id   = "customer"
  schema = file("../schemas/cleaned/customer.json")
  deletion_protection = false
}




