locals {
    #'Raw' table schema
    raw_schema = file("/Users/vvaneeclo/Projects/dgc-learning-path-data/dgc-learning-path-data-template/schemas/raw/store.json")

    #'Cleaned‘ table schema
    cleaned_schema = file("/Users/vvaneeclo/Projects/dgc-learning-path-data/dgc-learning-path-data-template/schemas/cleaned/store.json")
}

resource "google_bigquery_dataset" "raw" {
    dataset_id = "${var.project_id}_raw"
    description = "Raw data from the 'store.csv', 'customer.csv' & 'basket.json' files stored in the 'magasin_cie_landing/input' storage bucket."
    location = "EU"
}

resource "google_bigquery_dataset" "cleaned" {
    dataset_id = "${var.project_id}_cleaned"
    description = "Raw data from the 'store.csv', 'customer.csv' & 'basket.json' files stored in the 'magasin_cie_landing/input' storage bucket."
    location = "EU"
}

resource "google_bigquery_table" "raw_store" {
    dataset_id = google_bigquery_dataset.raw.dataset_id
    table_id = "${google_bigquery_dataset.cleaned.dataset_id}_store"
    schema = local.raw_schema
}

resource "google_bigquery_table" "cleaned_store" {
    dataset_id = google_bigquery_dataset.cleaned.dataset_id
    table_id = "${google_bigquery_dataset.cleaned.dataset_id}_store"
    schema = local.cleaned_schema
}

