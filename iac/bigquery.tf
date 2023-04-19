// Toutes les tables avec des données insérées avant que le schéma ne soit donné 
// ne veulent plus du schéma

resource "google_bigquery_dataset" "raw" {
    dataset_id = "raw"
    project = var.project_id
    description = "This is the raw table for Magasin&Cie"
    location = var.location
}

resource "google_bigquery_dataset" "cleaned" {
    dataset_id = "cleaned"
    project = var.project_id
    description = "This is the cleaned table for Magasin&Cie"
    location = var.location
}

resource "google_bigquery_dataset" "staging" {
    dataset_id = "staging"
    project = var.project_id
    description = "This is the staging table for Magasin&Cie"
    location = var.location
}

resource "google_bigquery_dataset" "aggregated" {
    dataset_id = "aggregated"
    project = var.project_id
    description = "This is the aggregated table for Magasin&Cie"
    location = var.location
}

resource "google_bigquery_table" "raw_tables" {
 for_each            = fileset(path.module, "../schemas/raw/*.json") 
 project             = var.project_id
 dataset_id          = google_bigquery_dataset.raw.dataset_id
 table_id            = trimsuffix(basename(each.value), ".json")
 schema              = file(each.value)
 deletion_protection = false
}

resource "google_bigquery_table" "staging_tables" {
 for_each            = fileset(path.module, "../schemas/staging/*.json") 
 project             = var.project_id
 dataset_id          = google_bigquery_dataset.staging.dataset_id
 table_id            = trimsuffix(basename(each.value), ".json")
 schema              = file(each.value)
 deletion_protection = false
}

resource "google_bigquery_table" "cleaned_tables" {
 for_each            = fileset(path.module, "../schemas/cleaned/*.json") 
 project             = var.project_id
 dataset_id          = google_bigquery_dataset.cleaned.dataset_id
 table_id            = trimsuffix(basename(each.value), ".json")
 schema              = file(each.value)
 deletion_protection = false
}

resource "google_bigquery_table" "aggregated_tables" {
 for_each            = fileset(path.module, "../schemas/aggregated/*.json") 
 project             = var.project_id
 dataset_id          = google_bigquery_dataset.aggregated.dataset_id
 table_id            = trimsuffix(basename(each.value), ".json")
 schema              = file(each.value)
 deletion_protection = false
}


resource "google_bigquery_table" "open_store"{
    project             = var.project_id
    dataset_id          = google_bigquery_dataset.aggregated.dataset_id
    table_id            = "open_store"
    view {
        query           = file("../queries/aggregated/open_store.sql")
        use_legacy_sql  = false
    }
}