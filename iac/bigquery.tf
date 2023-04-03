resource "google_bigquery_dataset" "dataset" {
    dataset_id = "${var.project_id}_raw"
    project_id = var.project_id
    friendly_name = "raw"
    description = "This is the raw table for Magasin&Cie"
    location = "EU"
}
