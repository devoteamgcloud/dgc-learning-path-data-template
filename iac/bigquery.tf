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

resource "google_bigquery_dataset" "aggregated" {
    dataset_id = "aggregated"
    project = var.project_id
    description = "This is the aggregated table for Magasin&Cie"
    location = "EU"
}

resource "google_bigquery_table" "store_raw" {
  dataset_id = google_bigquery_dataset.raw.dataset_id
  table_id   = "store"
  project = var.project_id
  schema = file("../schemas/raw/store.json")
  deletion_protection = false
}

resource "google_bigquery_table" "store_cleaned" {
  dataset_id = google_bigquery_dataset.cleaned.dataset_id
  table_id   = "store"
  project = var.project_id
  schema = file("../schemas/cleaned/store.json")
  deletion_protection = false
}

resource "google_bigquery_table" "customer_raw" {
  dataset_id = google_bigquery_dataset.raw.dataset_id
  table_id   = "customer"
  project = var.project_id
  schema = file("../schemas/raw/customer.json")
  deletion_protection = false
}

resource "google_bigquery_table" "customer_staging" {
  dataset_id = google_bigquery_dataset.staging.dataset_id
  table_id   = "customer"
  project = var.project_id
  schema = file("../schemas/staging/customer.json")
  deletion_protection = false
}

resource "google_bigquery_table" "customer_cleaned" {
  dataset_id = google_bigquery_dataset.cleaned.dataset_id
  table_id   = "customer"
  project = var.project_id
  schema = file("../schemas/cleaned/customer.json")
  deletion_protection = false
}

resource "google_bigquery_table" "basket_raw" {
  dataset_id = google_bigquery_dataset.raw.dataset_id
  table_id   = "basket"
  project = var.project_id
  schema = file("../schemas/raw/basket.json")
  deletion_protection = false
}

resource "google_bigquery_table" "basket_staging" {
  dataset_id = google_bigquery_dataset.staging.dataset_id
  table_id   = "basket"
  project = var.project_id
  schema = file("../schemas/staging/basket.json")
  deletion_protection = false
}

resource "google_bigquery_table" "basket_cleaned" {
  dataset_id = google_bigquery_dataset.cleaned.dataset_id
  table_id   = "basket_header"
  project = var.project_id
  schema = file("../schemas/cleaned/basket_header.json")
  deletion_protection = false
}

resource "google_bigquery_table" "basket_detail_staging" {
  dataset_id = google_bigquery_dataset.staging.dataset_id
  table_id   = "basket_detail"
  project = var.project_id
  schema = file("../schemas/staging/basket_detail.json")
  deletion_protection = false
}

resource "google_bigquery_table" "basket_detail_cleaned" {
  dataset_id = google_bigquery_dataset.cleaned.dataset_id
  table_id   = "basket_detail"
  project = var.project_id
  schema = file("../schemas/cleaned/basket_detail.json")
  deletion_protection = false
}

resource "google_bigquery_table" "day_sale_aggregated" {
  dataset_id = google_bigquery_dataset.aggregated.dataset_id
  table_id   = "day_sale"
  project = var.project_id
  schema = file("../schemas/aggregated/day_sale.json")
  deletion_protection = false
}

resource "google_bigquery_table" "best_product_sale_aggregated" {
  dataset_id = google_bigquery_dataset.aggregated.dataset_id
  table_id   = "best_product_sale"
  project = var.project_id
  schema = file("../schemas/aggregated/best_product_sale.json")
  deletion_protection = false
}