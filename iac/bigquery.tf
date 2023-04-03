resource "google_bigquery_dataset" "default" {
    dataset_id = "raw"
    project = var.project_id
    description = "This is the raw table for Magasin&Cie"
    location = "EU"
}

resource "google_bigquery_dataset" "default" {
    dataset_id = "cleaned"
    project = var.project_id
    description = "This is the cleaned table for Magasin&Cie"
    location = "EU"
}