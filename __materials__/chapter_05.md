# Learning Practical Path 

## Chapter 5 - Cloud Workflows & BigQuery Fundamentals (2 days)

![Your mission architecture](img/architecture_wkf.png)

### The Context

At this stage, you have successfully ingested the data of the stores. Magasin & Cie is really happy to work with you as you are a hard worker. 
The files sent have some differences. The stores are sent in a `full` mode, which means that every store data is sent each day to you through the file.
Yet it is not the case of the customer files. They are sent in a `delta` mode, which means that only the changes on the customers are sent each day. In other words, you will only receive the customer if they are new or if they have a change (for instance, a change in their email address).

Magasin & Cie now want you to create this delta integration with the customer's files into BigQuery. 

### The Learning Resources

You already had your first interaction with Workflows and BigQuery. It is now time to create by yourself the next workflows to integrate customers into BigQuery tables. 

To do so, of course you can start from the last workflow provided in this learning path, but it would be a good thing to look for the Google [Workflows documentation](https://cloud.google.com/workflows).

You can also check for [Workflows samples](https://cloud.google.com/workflows/docs/samples) of your choice.

Of course, the GCP gem is BigQuery, so do not try to rush, go through the [Google Certified Professional Data Engineer](https://learn.acloud.guru/course/gcp-certified-professional-data-engineer/overview) course Chapter 9 on A Cloud Guru. 

Do not hesitate to multiplicate the sources for instance:
- [Skills Boost catalog about Bigquery](https://www.cloudskillsboost.google/catalog?keywords=BigQuery). (For instance:
[Loading Your Own Data into BigQuery](https://www.cloudskillsboost.google/focuses/17816) or [BigQuery Soccer Data Ingestion](https://www.cloudskillsboost.google/focuses/23114))
- Articles on [Medium about Bigquery](https://medium.com/search?q=bigquery) if you have an account.
- and of couuuuuurse, the Google [BigQuery documentation](https://cloud.google.com/bigquery) is really great.

More specifically in your mission you will need to create queries so check for the [Query Syntax](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax). 

You will work with different [Data Types](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types), which have a [lexical structure](https://cloud.google.com/bigquery/docs/reference/standard-sql/lexical) and you will sometimes need to perform some [conversion](https://cloud.google.com/bigquery/docs/reference/standard-sql/conversion_rules) on it. 


Then you will need a `MERGE` statement, you can learn more about it in the [DML Syntax in the MERGE statement section](https://cloud.google.com/bigquery/docs/reference/standard-sql/dml-syntax#merge_statement).

### Your mission

Your mission here is to create the customer workflow to ingest and clean the data from the raw table. 

**To perform this chapter, please, use the `__materials__/data/20220602/customer_20220602.csv` file**.

#### "Mapping" you said ?

Before starting, we need to introduce you what a "Mapping" is.
The same way a Interface Contract is an aggreement and documents/rules the way the data is sent between two teams or applications, a mapping documents and rules the way data tables are related. It can take a lot of forms (here a Google Sheet). But the idea is to centralize how the data is transformed or related between different tables. 

In the [Interface Contracts & Mappings](https://docs.google.com/spreadsheets/d/1zjTwMemC_Qvyq7Xg9YABHeRZzoA9SBGV9J7-MBlJAIo/edit?usp=sharing), you will see that the tables in the `raw` dataset are defined by the Interface Contract tab. Then for each other dataset (cleaned or staging), you have a Mapping where you can see the fields of the tables. For instance, you know:
- what is the name of the fields and their type, mode, description etc.
- from which table does the data come from.
- if some transformation is applied.

In other words, it describes the data lineage.

Take the example of the store data we already have. 
- The `Interface Contracts` tab gives us the `raw.store` table schema: corresponding to the `schemas/raw/store.json` file.
- The `Mappings - cleaned` tab gives us the `cleaned.store` table schema in the `DESTINATION` side: corresponding to the `schemas/cleaned/store.json` file.
- The `Mappings - cleaned` tab gives the transformations applied to obtain `cleaned.store` table from the `raw.store` table: corresponding to the `queries/cleaned/store.sql` file.

#### Hard work in sight :p

Your mission is really simple to explain (not necessarily to perform of course):
- create the `raw.customer` table schema in a `schemas/raw/customer.json` file.
- create the `staging.customer` table schema in a `schemas/staging/customer.json` file.
- create the `cleaned.customer` table schema in a `schemas/cleaned/customer.json` file.
- build the query to insert data from `raw.customer` to `staging.customer` in a `queries/staging/customer.sql` file.
- build the query to `MERGE` (because of the delta mode) `staging.customer` into `cleaned.customer` in a `queries/cleaned/customer.sql` file 
- orchestrate all the workflow with a `cloud_workflows/customer_wkf.yaml`

#### Deploy everything with Terraform

Of course, everything must be deployed with Terraform at the end (even if it is probably better to write and test your queries in the BigQuery Console).

#### A little bit further before the deep dive

**When everything is done and works, please, use the `__materials__/data/20220603/customer_20220603.csv` file**.
Did you miss the deduplication ?
If yes, maybe the keywords `QUALIFY` and `ROW_NUMBER` will help you ;)

Check for this article on deduplication. 
[Deduplication in BigQuery Tables: A Comparative Study of 7 Approaches](https://medium.com/google-cloud/deduplication-in-bigquery-tables-a-comparative-study-of-7-approaches-f48966eeea2b?sk=674696a12c2a2f805ba885466773353b)

Why do we deduplicate our data in this delta integration ? Why not for the full integration of stores ?
