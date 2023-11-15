locals {
    raw_schema_content = file("./schemas/raw/store.json")
    raw_schema = jsondecode(local.raw_schema_content)

    cleaned_schema_content = file("./schemas/cleaned/store.json")
    cleaned_schema = jsondecode(local.cleaned_schema_content)
}

resource "google-bigquery-dataset" "raw" {
    dataset_id = "${var.project_id}_raw"
    description = ""
    location = "EU"
}

resource "google-bigquery-dataset" "cleaned" {
    dataset_id = "${var.project_id}_cleaned"
    description = ""
    location = "EU"
}

resource "google-bigquery-table" "raw_store" {
    dataset_id = google-bigquery-dataset.raw.dataset_id
    table_id = "{google-bigquery-dataset.cleaned.dataset_id}_store" #dont know how to parameter the table id considering the dataset_id
    time_partitioning {
        type = ""
    }
}

resource "google-bigquery-table" "cleaned_store" {
    dataset_id = google-bigquery-dataset.cleaned.dataset_id
    table_id = "{google-bigquery-dataset.cleaned.dataset_id}_store" #dont know how to parameter the table id considering the dataset_id
    schema = locals.cleaned_schema
    time_partitioning {
        type = ""
    }
}

