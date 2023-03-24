resource "google_bigquery_dataset" "dataset_raw" {
  project = var.project_id
  dataset_id                  = "raw"
  description                 = "This is the raw dataset"
  location                    = "EU"
}
resource "google_bigquery_dataset" "dataset_staging" {
  project = var.project_id
  dataset_id                  = "staging"
  description                 = "This is the staging dataset"
  location                    = "EU"
}
resource "google_bigquery_dataset" "dataset_cleaned" {
  project = var.project_id
  dataset_id                  = "cleaned"
  description                 = "This is the cleaned dataset"
  location                    = "EU"
}
resource "google_bigquery_dataset" "dataset_aggregated" {
  project = var.project_id
  dataset_id                  = "aggregated"
  description                 = "This is the aggregated dataset"
  location                    = "EU"
}

resource "google_bigquery_table" "table_store_raw" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_raw.dataset_id
  table_id   = "store"
  schema =file("../schemas/raw/store.json") 
  deletion_protection = false
}

resource "google_bigquery_table" "table_store_cleaned" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_cleaned.dataset_id
  table_id   = "store"
  schema =file("../schemas/cleaned/store.json")
  deletion_protection = false
}
resource "google_bigquery_table" "table_store_aggregated" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_aggregated.dataset_id
  table_id   = "open_store"
  deletion_protection = false
  view{
    query = file("../queries/aggregated/open_store.sql")
    use_legacy_sql = false
  }
  depends_on = [
    google_bigquery_table.table_store_cleaned
  ]
}
resource "google_bigquery_table" "table_customer_raw" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_raw.dataset_id
  table_id   = "customer"
  schema =file("../schemas/raw/customer.json") 
  deletion_protection = false
}

resource "google_bigquery_table" "table_customer_staging" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_staging.dataset_id
  table_id   = "customer"
  schema =file("../schemas/staging/customer.json") 
  deletion_protection = false
}

resource "google_bigquery_table" "table_customer_cleaned" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_cleaned.dataset_id
  table_id   = "customer"
  schema =file("../schemas/cleaned/customer.json")
  deletion_protection = false
}
resource "google_bigquery_table" "table_customer_purchase_aggregated" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_aggregated.dataset_id
  table_id   = "customer_purchase"
  deletion_protection = false
  view{
    query = file("../queries/aggregated/customer_purchase.sql")
    use_legacy_sql = false
  }
}
resource "google_bigquery_table" "table_basket_raw" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_raw.dataset_id
  table_id   = "basket"
  schema =file("../schemas/raw/basket.json") 
  deletion_protection = false
}

resource "google_bigquery_table" "table_basket_staging" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_staging.dataset_id
  table_id   = "basket"
  schema =file("../schemas/staging/basket.json") 
  deletion_protection = false
}
resource "google_bigquery_table" "table_basket_detail_staging" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_staging.dataset_id
  table_id   = "basket_detail"
  schema =file("../schemas/staging/basket_detail.json") 
  deletion_protection = false
}
resource "google_bigquery_table" "table_basket_detail_cleaned" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_cleaned.dataset_id
  table_id   = "basket_detail"
  schema =file("../schemas/cleaned/basket_detail.json") 
  deletion_protection = false
}
resource "google_bigquery_table" "table_basket_header_cleaned" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_cleaned.dataset_id
  table_id   = "basket_header"
  schema =file("../schemas/cleaned/basket_header.json")
  deletion_protection = false
}
resource "google_bigquery_table" "table_day_sale" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_aggregated.dataset_id
  table_id   = "day_sale"
  schema =file("../schemas/aggregated/day_sale.json") 
  deletion_protection = false
}
resource "google_bigquery_table" "table_best_product_sale" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.dataset_aggregated.dataset_id
  table_id   = "best_product_sale"
  schema =file("../schemas/aggregated/best_product_sale.json")
  deletion_protection = false
}

#Policies
resource "google_project_service" "datacatalog_api" {
  project = var.project_id
  service = "datacatalog.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_iam_policy" "project" {
  project     = var.project_id
  policy_data = data.google_iam_policy.admin.policy_data
}
data "google_iam_policy" "admin" {
  binding {
    role = "roles/editor"

    members = [
      "user:362450662442-compute@developer.gserviceaccount.com",
    ]
  }
}
resource "google_data_catalog_taxonomy" "my_taxonomy" {
  project = var.project_id
  region = var.region
  display_name =  "my_taxonomy"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
  depends_on = [google_project_service.datacatalog_api]
}

resource "google_data_catalog_policy_tag" "basic_policy_tag" {
  taxonomy = google_data_catalog_taxonomy.my_taxonomy.display_name
  display_name = "basic_policy_tag"
  depends_on = [google_data_catalog_taxonomy.my_taxonomy]
}