resource "google_bigquery_dataset" "dataset" {
  for_each = {
    "raw"     = "Dataset for raw data",
    "cleaned" = "Dataset for clean data"
  }
  dataset_id  = each.key
  description = each.value
  location    = var.location
}



