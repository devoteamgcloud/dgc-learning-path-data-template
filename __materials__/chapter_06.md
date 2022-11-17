# Learning Practical Path 


**[WORK IN PROGRESS]**


## Chapter 6 - Advanced SQL & GDPR (3 days)

![Your mission architecture](img/architecture_bigquery.png)

### The Context
### The Learning Resources

At this stage, yes yes it will be harder but I think you will be more autonomous. And as lazy I am, I think you are ready to find by yourself the learning ressources.

> Just a hint: https://www.google.com/
> An other really great hint: **your amazing colleagues**
### Your mission

BigQuery Skill boost
[Creating a Data Warehouse Through Joins and Unions](https://www.cloudskillsboost.google/focuses/3640)
[Build and Optimize Data Warehouses with BigQuery: Challenge Lab](https://www.cloudskillsboost.google/focuses/14341)
[Insights from Data with BigQuery: Challenge Lab](https://www.cloudskillsboost.google/focuses/11988)
[Getting Started with BigQuery GIS for Data Analysts](https://www.cloudskillsboost.google/focuses/17817)

partitions? View ? 

NESTED REPEATED
https://cloud.google.com/bigquery/docs/nested-repeated
https://cloud.google.com/bigquery/docs/best-practices-performance-nested
https://www.cloudskillsboost.google/focuses/3696?parent=catalog
https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#select_as_struct

- first create a `staging.basket_temp` table only with 1-1 transformation from `raw.basket`.
- then dedupicate the detail on `product_name` updating the `staging.basket_temp` table in place (really hard). 
- create `staging.basket` table joining with `cleaned.basket_header` table to retrieve existing basket headers ids and keep the new header as `NULL`. 
- and update the `staging.basket` table in place to fill the NULL (new) basket headers with an incremental value starting from the last id known in the `cleaned.basket_header` table.
- to be clean, delete the temporary table `staging.basket_temp`.

By the end you will have the completed the pipeline architecture with those files.

```
./
├── README.md
├── cloudbuild.yaml
├── __materials__/
│   ...
│  
├── cloud_functions/
│   ├── cf_dispatch_workflow/
│   │   ├── env.yaml
│   │   └── src/
│   │       ├── main.py
│   │       └── requirements.txt
│   └── cf_trigger_on_file/
│       ├── env.yaml
│       └── src/
│           ├── main.py
│           └── requirements.txt
├── cloud_storage/
│   └── magasin-cie-landing_lifecycle.json
├── cloud_workflows/
│   ├── basket_wkf.yaml
│   ├── customer_wkf.yaml
│   └── store_wkf.yaml
├── iac/
│   ├── backend.tf
│   ├── bigquery.tf
│   ├── cloud_functions.tf
│   ├── cloud_storage.tf
│   ├── init/
│   │   └── init.sh
│   ├── pubsub.tf
│   └── variable.tf
├── queries/
│   ├── aggregated/
│   │   ├── best_product_sale.sql
│   │   ├── customer_purchase.sql
│   │   ├── day_sale.sql
│   │   └── open_store.sql
│   ├── cleaned/
│   │   ├── basket_detail.sql
│   │   ├── basket_header.sql
│   │   ├── customer.sql
│   │   └── store.sql
│   └── staging/
│       ├── basket.sql
│       ├── basket_detail.sql
│       └── customer.sql
└── schemas/
    ├── aggregated/
    │   ├── best_product_sale.sql
    │   ├── customer_purchase.sql (no need)
    │   ├── day_sale.sql
    │   └── open_store.sql (no need)
    ├── cleaned/
    │   ├── basket_detail.json
    │   ├── basket_header.json
    │   ├── customer.json
    │   └── store.json
    ├── raw/
    │   ├── basket.json
    │   ├── customer.json
    │   └── store.json
    └── staging/
        ├── basket.json
        ├── basket_detail.json
        └── customer.json
```