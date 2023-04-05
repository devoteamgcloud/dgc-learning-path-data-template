
# Datasets

resource "google_bigquery_dataset" "raw" {
  project             = var.project_id
  dataset_id          = "raw"
  description         = "A dataset for raw data"
  location            = var.location
}

resource "google_bigquery_dataset" "staging" {
  project             = var.project_id
  dataset_id          = "staging"
  description         = "A dataset for staging data"
  location            = var.location
}

resource "google_bigquery_dataset" "cleaned" {
  project             = var.project_id
  dataset_id          = "cleaned"
  description         = "A dataset for cleaned data"
  location            = var.location
}

resource "google_bigquery_dataset" "aggregated" {
  project             = var.project_id
  dataset_id          = "aggregated"
  description         = "A dataset for aggregated data"
  location            = var.location
}

# Tables raw layer

resource "google_bigquery_table" "raw_tables" {
  for_each            = fileset(path.module, "../schemas/raw/*.json")  # [MENTOR #2]
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.raw.dataset_id
  table_id            = trimsuffix(basename(each.value), ".json")
  schema              = file(each.value)
  deletion_protection = false
}

# Tables staging layer

resource "google_bigquery_table" "staging_tables" {
  for_each            = fileset(path.module, "../schemas/staging/*.json")  # [MENTOR #2]
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.staging.dataset_id
  table_id            = trimsuffix(basename(each.value), ".json")
  schema              = file(each.value)
  deletion_protection = false
}

# Tables cleaned layer

resource "google_bigquery_table" "cleaned_tables" {
  for_each            = fileset(path.module, "../schemas/cleaned/*.json")  # [MENTOR #2]
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.cleaned.dataset_id
  table_id            = trimsuffix(basename(each.value), ".json")
  schema              = file(each.value)
  deletion_protection = false
}

# Tables cleaned layer

resource "google_bigquery_table" "aggregated_tables_and_views" {
  for_each            = fileset(path.module, "../schemas/aggregated/*.json")
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.aggregated.dataset_id
  table_id            = trimsuffix(basename(each.value), ".json")
  schema              = file(each.value)
  deletion_protection = false
}

resource "google_bigquery_table" "view_open_store" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.aggregated.dataset_id
  table_id   = "open_store"
  view {
    query          = file("../queries/aggregated/open_store.sql")
    use_legacy_sql = false
  }
}

resource "google_bigquery_table" "view_customer_purchase" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.aggregated.dataset_id
  table_id   = "customer_purchase"
  view {
    query          = file("../queries/aggregated/customer_purchase.sql")
    use_legacy_sql = false
  }
}
