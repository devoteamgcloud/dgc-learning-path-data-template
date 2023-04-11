resource "google_bigquery_dataset" "raw_dataset" {
    dataset_id                  = "raw"
    project                     = var.project_id
    friendly_name               = "raw_dataset"
}

resource "google_bigquery_table" "raw_dataset" {
    dataset_id                    = google_bigquery_dataset.raw_dataset.dataset_id
    table_id                      = "store"
    project                     = var.project_id

    schema = file("../schemas/raw/store.json")

}

resource "google_bigquery_dataset" "cleaned_dataset" {
    dataset_id                  = "cleaned"
    project                     = var.project_id
    friendly_name               = "cleaned_dataset"
}

resource "google_bigquery_table" "cleaned_dataset" {
    dataset_id = google_bigquery_dataset.cleaned_dataset.dataset_id
    table_id   = "store"
    project                     = var.project_id

    schema = file("../schemas/cleaned/store.json")

}
