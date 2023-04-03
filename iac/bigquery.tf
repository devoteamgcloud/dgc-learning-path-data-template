resource "google_bigquery_dataset" "default" {
    dataset_id = "${var.project_id}_raw"
    friendly_name = "raw"
    description = "This is the raw table for Magasin&Cie"
    location = "EU"
}
