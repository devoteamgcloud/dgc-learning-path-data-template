/*
CONTEXT:
- This query creates the staging.basket table in the basket workflow.

RESULT EXPECTATION:
- This query should create a staging.basket table with deduplicated `detail` subtable (by detail.product_name) and a `id_basket_header` coherent with the other tables in the workflow.

ASSUMPTION:
- In the `UPDATE staging.basket` statement, the staging.basket_header.id_basket_header row needs to be NOT NULL in order to have the staging.basket.id_basket_header not always equal to 1.
*/

/*
Create the staging.basket_temp table without deduplication.
*/

CREATE OR REPLACE TABLE `{{ project_id }}.staging.basket_temp` AS (
  SELECT
    NULL AS id_basket_header,
    CAST(TRIM(SPLIT(id_cash_desk, "-")[0], "0") AS INT) AS id_store,
    CAST(TRIM(SPLIT(id_cash_desk, "-")[1], "0") AS INT) AS id_cash_desk,
    id_customer,
    detail,
    payment_mode,
    PARSE_DATETIME('%d-%m-%Y %H:%M:%S', purchase_date) AS purchase_date,
    update_time,
    CURRENT_TIMESTAMP() AS `insertion_time`
  FROM
    `{{ project_id }}.raw.basket`
  QUALIFY ROW_NUMBER() OVER(
  PARTITION BY 
    id_store, 
    id_cash_desk, 
    id_customer, 
    purchase_date 
  ORDER BY 
    update_time DESC
) = 1);


/*
Deduplicate the detail subtable (or nested table) from staging.basket_temp in place.
*/

MERGE `{{ project_id }}.staging.basket_temp` AS T
USING (
  -- CTE to deduplicate the `detail` subtable (or nested table) in place.
  WITH deduplicated_detail AS (
    SELECT
      -- PK
      id_basket_header,
      id_cash_desk,
      purchase_date,
      -- details
      STRUCT(
          details.product_name AS product_name,
          SUM(details.quantity) AS quantity,
          ROUND(SUM(details.unit_price)/COUNT(details.product_name), 2) AS unit_price
        ) AS detail
    FROM
      `{{ project_id }}.staging.basket_temp`,
      UNNEST(detail) AS details
    GROUP BY
      -- Group by PK & product_name to deduplicate
      id_store,
      id_basket_header,
      id_cash_desk,
      purchase_date,
      details.product_name
  )
  -- SELECT the new deduplicated detail FROM the `deduplicated_detail` CTE.
  SELECT
    id_basket_header,
    id_cash_desk,
    purchase_date,
    ARRAY_AGG(detail) AS detail
  FROM
    deduplicated_detail
  GROUP BY   
    id_basket_header,
    id_cash_desk,
    purchase_date
) AS S
ON T.id_basket_header = S.id_basket_header AND S.id_cash_desk = T.id_cash_desk AND S.purchase_date = T.purchase_date
WHEN MATCHED THEN
  UPDATE SET
    detail = S.detail;

/*
Create table staging.basket by LEFT JOINING staging.basket_temp with cleaned.basket_header:
  - staging_basket_temp.* EXCEPT(id_basket_header): takes all columns but id_basket_header which we take from cleaned_basket_header.
  - LEFT JOIN on cleaned.basket_header PK: id_basket_header.
*/

CREATE OR REPLACE TABLE `{{ project_id }}.staging.basket` AS (
  SELECT
    cleaned_basket_header.id_basket_header,
    staging_basket_temp.* EXCEPT(id_basket_header)
  FROM
    `{{ project_id }}.staging.basket_temp` staging_basket_temp
  LEFT JOIN
    `{{ project_id }}.cleaned.basket_header` cleaned_basket_header
  ON staging_basket_temp.id_basket_header = cleaned_basket_header.id_basket_header
);


/*
Update the staging.basket table in place:
  - COALESCE(MAX(id_basket_header), 0) + ROW_NUMBER() OVER (): Calculates the new header values by adding the maximum existing header (or 0 if none exist) to the sequential row numbers.

Assumption:
  - The staging.basket_header table needs to be NOT NULL for this to work, otherwise, all id_basket_header will be equal to 1. 
*/
 
UPDATE `{{ project_id }}.staging.basket` staging_basket
SET staging_basket.id_basket_header = tmp.id_basket_header 
FROM (SELECT id_cash_desk, id_customer, purchase_date, id_store, (SELECT MAX(id_basket_header) FROM `{{ project_id }}.cleaned.basket_header`) + ROW_NUMBER() OVER() AS id_basket_header FROM `{{ project_id }}.staging.basket` WHERE id_basket_header IS NULL) tmp 
WHERE
  tmp.id_cash_desk = staging_basket.id_cash_desk 
  AND tmp.id_customer = staging_basket.id_customer
  AND tmp.purchase_date = staging_basket.purchase_date
  AND tmp.id_store = staging_basket.id_store;

DROP TABLE IF EXISTS `{{ project_id }}.staging.basket_temp`;