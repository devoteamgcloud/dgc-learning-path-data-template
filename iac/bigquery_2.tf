locals {
  ### Datasets config ###
  dataset_config = {
    "raw" = {
      dataset_id  = "${replace(var.project_id, "-", "_")}_raw"
      description = "Raw data from the 'store.csv', 'customer.csv ' & 'basket.json' files stored in the 'magasin_cie_landing/input' storage bucket."
      location    = "EU"
    }

    "cleaned" = {
      dataset_id  = "${replace(var.project_id, "-", "_")}_cleaned"
      description = "Raw data from the 'store.csv', 'customer.csv' & 'basket.json' files stored in the 'magasin_cie_landing/input' storage bucket."
      location    = "EU"
    }
  }

  ### Tables config ###
  tables_config = {
    "raw_store" = {
      dataset_id = "${local.dataset_config.raw.dataset_id}"
      table_id   = "${local.dataset_config.raw.dataset_id}_store"
      schema     = file("${var.raw_schema_path}")
    }

    "cleaned_store" = {
      dataset_id = "${local.dataset_config.cleaned.dataset_id}"
      table_id   = "${local.dataset_config.cleaned.dataset_id}_store"
      schema     = file("${var.cleaned_schema_path}")
    }
  }
}

resource "google_bigquery_dataset" "datasets" {
  for_each   = local.dataset_config
  dataset_id = each.value.dataset_id
  description = each.value.description
}

resource "google_bigquery_table" "tables" {
  for_each    = local.tables_config
  dataset_id  = each.value.dataset_id
  table_id = each.value.table_id
  schema = each.value.schema
}

