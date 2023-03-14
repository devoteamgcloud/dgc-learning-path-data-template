resource "google_bigquery_dataset" "raw_dataset" {
    dataset_id = "raw_dataset"
    friendly_name = "raw"
    description = "A test dataset _ learning path"
    location = "EU"
    default_table_expiration_ms = 3600000
}
resource "google_service_account" "bqowner" {
    account_id = "bqowner"
}
resource "google_bigquery_dataset" "cleaned_dataset" {
    dataset_id = "cleaned_dataset"
    friendly_name = "cleaned"
    description = "A test cleaned dataset _ learning path"
    location = "EU"
    default_table_expiration_ms = 3600000
}
resource "google_bigquery_table" "json" {
    dataset_id = google_bigquery_dataset.raw_dataset.dataset_id
    table_id = "raw"
    
    labels = {
        env = "default"
    }

    schema = file("../schemas/raw/store.json")
}
resource "google_bigquery_table" "json2" {
    dataset_id = google_bigquery_dataset.cleaned_dataset.dataset_id
    table_id = "cleaned"
    
    labels = {
        env = "default"
    }

    schema = file("../schemas/cleaned/store.json")
}
