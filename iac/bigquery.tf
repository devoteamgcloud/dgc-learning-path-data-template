resource "google_bigquery_dataset" "dataset" {
    project  = var.project_id
    dataset_id                  = "${var.project_id}_raw"
    friendly_name               = "raw"
    description                 = "This is the raw table for Magasin&Cie"
    location                    = "EU"
}

    resource "google_service_account" "bqowner" {
    account_id = "bqowner"
}