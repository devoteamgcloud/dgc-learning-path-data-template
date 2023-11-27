locals {
  dataset_config = {
    "raw" = {
      dataset_id  = "${replace(var.project_id, "-", "_")}_raw"
      description = "Raw data from the 'store.csv', 'customer.csv ' & 'basket.json' files stored in the 'magasin_cie_landing/input' storage bucket."
      location    = "EU"
    }

    "staging" = {
      dataset_id  = "${replace(var.project_id, "-", "_")}_staging"
      description = "Staging data from the 'store.csv', 'customer.csv' & 'basket.json' files stored in the 'magasin_cie_landing/input' storage bucket."
      location    = "EU"
    }

    "cleaned" = {
      dataset_id  = "${replace(var.project_id, "-", "_")}_cleaned"
      description = "Cleaned data from the 'store.csv', 'customer.csv' & 'basket.json' files stored in the 'magasin_cie_landing/input' storage bucket."
      location    = "EU"
    }

     "aggregated" = {
      dataset_id  = "${replace(var.project_id, "-", "_")}_aggregated"
      description = "Aggregated data from the 'store.csv', 'customer.csv' & 'basket.json' files stored in the 'magasin_cie_landing/input' storage bucket."
      location    = "EU"
    }
  }

  ### TABLES ###
  tables_config = {
    ### Raw ###
    "raw_store" = {
      dataset_id = "${local.dataset_config.raw.dataset_id}"
      table_id   = "${local.dataset_config.raw.dataset_id}_store"
      schema     = file("${var.raw_store_schema_path}")
    }

    "raw_customer" = {
      dataset_id = "${local.dataset_config.raw.dataset_id}"
      table_id   = "${local.dataset_config.raw.dataset_id}_customer"
      schema     = file("${var.raw_customer_schema_path}")
    }

    "raw_basket" = {
      dataset_id = "${local.dataset_config.raw.dataset_id}"
      table_id   = "${local.dataset_config.raw.dataset_id}_basket"
      schema     = file("${var.raw_basket_schema_path}")
    }

    ### Staging ###
    "staging_customer" = {
      dataset_id = "${local.dataset_config.staging.dataset_id}"
      table_id   = "${local.dataset_config.staging.dataset_id}_customer"
      schema     = file("${var.staging_customer_schema_path}")
    }

    "staging_basket" = {
      dataset_id = "${local.dataset_config.staging.dataset_id}"
      table_id   = "${local.dataset_config.staging.dataset_id}_basket"
      schema     = file("${var.staging_basket_schema_path}")
    }

    "staging_basket_detail" = {
      dataset_id = "${local.dataset_config.staging.dataset_id}"
      table_id   = "${local.dataset_config.staging.dataset_id}_basket_detail"
      schema     = file("${var.staging_basket_detail_schema_path}")
    }

    ### Cleaned ###
    "cleaned_store" = {
      dataset_id = "${local.dataset_config.cleaned.dataset_id}"
      table_id   = "${local.dataset_config.cleaned.dataset_id}_store"
      schema     = file("${var.cleaned_store_schema_path}")
    }

    "cleaned_customer" = {
      dataset_id = "${local.dataset_config.cleaned.dataset_id}"
      table_id   = "${local.dataset_config.cleaned.dataset_id}_customer"
      schema     = file("${var.cleaned_customer_schema_path}")
    }

    "cleaned_basket_header" = {
      dataset_id = "${local.dataset_config.cleaned.dataset_id}"
      table_id   = "${local.dataset_config.cleaned.dataset_id}_basket_header"
      schema     = file("${var.cleaned_basket_header_schema_path}")
    }

    "cleaned_basket_detail" = {
      dataset_id = "${local.dataset_config.cleaned.dataset_id}"
      table_id   = "${local.dataset_config.cleaned.dataset_id}_basket_detail"
      schema     = file("${var.cleaned_basket_detail_schema_path}")
    }

    ### Aggregated ###
    "open_store" = {
      dataset_id = "${local.dataset_config.aggregated.dataset_id}"
      table_id   = "${local.dataset_config.aggregated.dataset_id}_open_store"
      schema     = file("${var.open_store_schema_path}")
    }

    "customer_purchase" = {
      dataset_id = "${local.dataset_config.aggregated.dataset_id}"
      table_id   = "${local.dataset_config.aggregated.dataset_id}_customer_purchase"
      schema     = file("${var.customer_purchase_schema_path}")
    }

    "day_sale" = {
      dataset_id = "${local.dataset_config.aggregated.dataset_id}"
      table_id   = "${local.dataset_config.aggregated.dataset_id}_day_sale"
      schema     = file("${var.day_sale_header_schema_path}")
    }

    "best_product_sale" = {
      dataset_id = "${local.dataset_config.aggregated.dataset_id}"
      table_id   = "${local.dataset_config.aggregated.dataset_id}_best_product_sale"
      schema     = file("${var.best_product_sale_schema_path}")
    }
  }
  
}
resource "google_bigquery_dataset" "datasets" {
  for_each    = local.dataset_config
  dataset_id  = each.value.dataset_id
  description = each.value.description
}

resource "google_bigquery_table" "tables" {
  for_each   = local.tables_config
  dataset_id = each.value.dataset_id
  table_id   = each.value.table_id
  schema     = each.value.schema
}