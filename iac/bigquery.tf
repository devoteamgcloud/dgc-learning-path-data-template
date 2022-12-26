resource "google_bigquery_dataset" "raw" {
    project  = var.project_id
    dataset_id                  = "raw"
    friendly_name               = "raw"
    description                 = "This is a raw dataset"
    location                    = "EU"

}
resource "google_bigquery_dataset" "cleaned" {
    project  = var.project_id
    dataset_id                  = "cleaned"
    friendly_name               = "cleaned"
    description                 = "This is a cleaned dataset"
    location                    = "EU"

}

resource "google_bigquery_table" "raw_store" {
    project  = var.project_id
  dataset_id = google_bigquery_dataset.raw.dataset_id
  table_id   = "store"

  schema = <<EOF
[
    {
        "name": "id_store",
        "type": "STRING",
        "mode": "REQUIRED",
        "description": "Unique ID of the store"
    },
    {
        "name": "id_manager",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "Unique ID of the main manager"
    },
    {
        "name": "city",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "City of the store"
    },
    {
        "name": "country",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "Country of the store"
    },
    {
        "name": "x_coordinate",
        "type": "FLOAT",
        "mode": "NULLABLE",
        "description": "x coordinate of the store"
    },
    {
        "name": "y_coordinate",
        "type": "FLOAT",
        "mode": "NULLABLE",
        "description": "y coordinate of the store"
    },
    {
        "name": "is_closed",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "If it is permanently closed"
    },
    {
        "name": "creation_date",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "Date of store openning"
    },
    {
        "name": "update_time",
        "type": "TIMESTAMP",
        "mode": "NULLABLE",
        "description": "Time of record update"
    }
]
EOF

}
resource "google_bigquery_table" "cleaned_store" {
    project  = var.project_id

  dataset_id = google_bigquery_dataset.cleaned.dataset_id
  table_id   = "store"

  schema = <<EOF
[
    {
        "name": "id_store",
        "type": "INTEGER",
        "mode": "REQUIRED",
        "description": "Unique ID of the store"
    },
    {
        "name": "id_manager",
        "type": "INTEGER",
        "mode": "NULLABLE",
        "description": "Unique ID of the main manager"
    },
    {
        "name": "city",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "City of the store"
    },
    {
        "name": "country",
        "type": "STRING",
        "mode": "NULLABLE",
        "description": "Country of the store"
    },
    {
        "name": "coordinate",
        "type": "GEOGRAPHY",
        "mode": "NULLABLE",
        "description": "x coordinate of the store"
    },
    {
        "name": "is_closed",
        "type": "BOOLEAN",
        "mode": "NULLABLE",
        "description": "If it is permanently closed"
    },
    {
        "name": "creation_date",
        "type": "DATE",
        "mode": "NULLABLE",
        "description": "Date of store openning"
    },
    {
        "name": "update_time",
        "type": "TIMESTAMP",
        "mode": "NULLABLE",
        "description": "Time of record update"
    },
    {
        "name": "insertion_time",
        "type": "TIMESTAMP",
        "mode": "NULLABLE",
        "description": "Time of the record insertion"
    }
]
EOF

}
