resource "google_bigquery_dataset" "raw" {
  project             = var.project_id
  dataset_id          = "raw"
  description         = "A dataset for raw data"
  location            = var.location
}

resource "google_bigquery_dataset" "cleaned" {
  project             = var.project_id
  dataset_id          = "cleaned"
  description         = "A dataset for cleaned data"
  location            = var.location
}

resource "google_bigquery_dataset" "staging" {
  project             = var.project_id
  dataset_id          = "staging"
  description         = "A dataset for staging data"
  location            = var.location
}

resource "google_bigquery_dataset" "aggregated" {
  project             = var.project_id
  dataset_id          = "aggregated"
  description         = "A dataset for aggregated data"
  location            = var.location
}

resource "google_bigquery_table" "raw_store" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.raw.dataset_id
  table_id            = "store"
  schema              = file("../schemas/raw/store.json")
  deletion_protection = false
}

resource "google_bigquery_table" "raw_customer" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.raw.dataset_id
  table_id            = "customer"
  schema              = file("../schemas/raw/customer.json")
  deletion_protection = false
}

resource "google_bigquery_table" "raw_basket" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.raw.dataset_id
  table_id            = "basket"
  schema              = file("../schemas/raw/basket.json")
  deletion_protection = false
}

resource "google_bigquery_table" "staging_customer" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.staging.dataset_id
  table_id            = "customer"
  schema              = file("../schemas/staging/customer.json")
  deletion_protection = false
}

resource "google_bigquery_table" "staging_basket" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.staging.dataset_id
  table_id            = "basket"
  schema              = file("../schemas/staging/basket.json")
  deletion_protection = false
}

resource "google_bigquery_table" "staging_basket_detail" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.staging.dataset_id
  table_id            = "basket_detail"
  schema              = file("../schemas/staging/basket_detail.json")
  deletion_protection = false
}
resource "google_bigquery_table" "cleaned_store" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.cleaned.dataset_id
  table_id            = "store"
  schema              = file("../schemas/cleaned/store.json")
  deletion_protection = false
}

resource "google_bigquery_table" "cleaned_customer" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.cleaned.dataset_id
  table_id            = "customer"
  schema              = file("../schemas/cleaned/customer.json")
  deletion_protection = false
}

resource "google_bigquery_table" "cleaned_basket_detail" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.cleaned.dataset_id
  table_id            = "basket_detail"
  schema              = file("../schemas/cleaned/basket_detail.json")
  deletion_protection = false
}

resource "google_bigquery_table" "cleaned_basket_header" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.cleaned.dataset_id
  table_id            = "basket_header"
  schema              = file("../schemas/cleaned/basket_header.json")
  deletion_protection = false
}

resource "google_bigquery_table" "aggregated_day_sale" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.aggregated.dataset_id
  table_id            = "day_sale"
  schema              = file("../schemas/aggregated/day_sale.json")
  deletion_protection = false
}

resource "google_bigquery_table" "aggregated_best_product_sale" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.aggregated.dataset_id
  table_id            = "best_product_sale"
  schema              = file("../schemas/aggregated/best_product_sale.json")
  deletion_protection = false
}

resource "google_bigquery_table" "view_open_store" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.aggregated.dataset_id
  table_id            = "open_store"
  view {
    query             = file("../queries/aggregated/open_store.sql")
    use_legacy_sql    = false
  }
}

resource "google_bigquery_table" "view_customer_purchase" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.aggregated.dataset_id
  table_id            = "customer_purchase"
  view {
    query             = file("../queries/aggregated/customer_purchase.sql")
    use_legacy_sql    = false
  }
}

resource "google_bigquery_table" "view_cash_desk_transaction" {
  project             = var.project_id
  dataset_id          = google_bigquery_dataset.aggregated.dataset_id
  table_id            = "cash_desk_transaction"
  view {
    query             = file("../queries/aggregated/cash_desk_transaction.sql")
    use_legacy_sql    = false
  }
  
}
