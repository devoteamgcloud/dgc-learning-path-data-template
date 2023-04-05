/*. ______PROCEDURAL QUERY______
*/


/*
  Gets the last basket header ID in the cleaned dataset. 
  It will be helpful as all the new IDs will be created incrementally from this last ID number.
*/
DECLARE max_id_basket_header INT64;
SET max_id_basket_header = (SELECT IFNULL(MAX(id_basket_header), 0) FROM `{{ project_id }}.cleaned.basket_header`);


/*
  Creates a temporary tables with the simplest transformation in first time. 
  It means it transform the data from raw execpt the `detail` which is harder to compute

  Note: this handles deduplication so no need to deduplicate again then.
*/
CREATE OR REPLACE TABLE `{{ project_id }}.staging.basket_temp` AS
SELECT 
  CAST(SPLIT(id_cash_desk, '-')[SAFE_OFFSET(0)] AS INTEGER) AS `id_store`,
  CAST(SPLIT(id_cash_desk, '-')[SAFE_OFFSET(1)] AS INTEGER) AS `id_cash_desk`,
  id_customer,
  detail,
  IF(payment_mode = "Cash", "Cash", "Card")                 AS `payment_mode`,
  PARSE_DATETIME("%d-%m-%Y %H:%M:%S", purchase_date)        AS `purchase_date`,
  update_time,
  CURRENT_TIMESTAMP()                                       AS `insertion_time`, 
FROM `{{ project_id }}.raw.basket`
QUALIFY ROW_NUMBER() OVER(
  PARTITION BY 
    id_store, 
    id_cash_desk, 
    id_customer, 
    purchase_date 
  ORDER BY 
    update_time DESC
) = 1
; 

/* 
  REALLY REALLY HARD ! 

  Update from the temporary table (in-place changes with `UPDATE`) the detail. 

  The `ARRAY(...)` specifies a list (REPEATED)
  And the `SELECT AS STRUCT` specifies the struct (RECORD)
  So this statement recomputes the detail as a RECORD REPEATED. 

  This record is a deduplication of rows (given product_name as PK in the `GROUP BY`)
  Then recomputes the reduced value from those duplicates:
    - reduced `quantity` is the sum of the `quantity` over the duplicates
    - reduced `unit_price` is the ponderated mean of `unit_price` over the duplicates

  The WHERE clause is Optional. 
  It will count the number of detail's lines and compare to the number of disctinct lines (PK is product_name)
  If the WHERE clause exists, it will only recompute the detail with duplicated records. 
  If the WHERE clause does not exist, it will recompute everyhing (but the values for non-duplicates will not change)
*/
UPDATE `{{ project_id }}.staging.basket_temp`
SET 
  detail = ARRAY(
    SELECT AS STRUCT 
      product_name, 
      SUM(quantity)                                        AS `quantity`,
      ROUND(SUM(quantity * unit_price) / SUM(quantity), 2) AS `unit_price`
    FROM UNNEST(detail)
    GROUP BY product_name
  ) 
WHERE (SELECT COUNT(product_name) FROM UNNEST(detail)) <> (SELECT COUNT(DISTINCT product_name) FROM UNNEST(detail))
;


/*
  Data is now transformed as the schema of the cleaned basket header supports. (detail in addition)
  So we can create the staging table containing those transforms rows. 

  The `LEFT JOIN` helps to identify if the element (identified with PKs) already exists in the cleaned table. 
  If yes, then, retrieve its ID from the cleaned table. 
  If no, it will remain NULL. 

*/
CREATE OR REPLACE TABLE `{{ project_id }}.staging.basket` AS
SELECT 
  header.id_basket_header,
  staging_basket.id_store,
  staging_basket.id_cash_desk,
  staging_basket.id_customer,
  staging_basket.detail,
  staging_basket.payment_mode,
  staging_basket.purchase_date,
  staging_basket.update_time,
  staging_basket.insertion_time,
FROM `{{ project_id }}.staging.basket_temp` staging_basket
LEFT JOIN `{{ project_id }}.cleaned.basket_header` header 
  ON staging_basket.id_store      = header.id_store
 AND staging_basket.id_cash_desk  = header.id_cash_desk
 AND staging_basket.id_customer   = header.id_customer
 AND staging_basket.purchase_date = header.purchase_date
;


/*
  From the staging table, the `id_basket_header` with NULL values are the news elements (given PKs)
  So we need to set a new IDs to those rows incrementally from the last known ID. 

  So the subquery `new_element_staging_basket` creates this incremental ID
  with the `max_id_basket_header + ROW_NUMBER() OVER()` statement

  The id_basket_header is then in-place modified. (UPDATE) 

*/
UPDATE `{{ project_id }}.staging.basket` staging_basket
SET 
    staging_basket.id_basket_header = new_element_staging_basket.id_basket_header
FROM (
    SELECT 
        id_store, 
        id_cash_desk,
        id_customer,
        purchase_date,
        max_id_basket_header + ROW_NUMBER() OVER() AS `id_basket_header`,
    FROM `{{ project_id }}.staging.basket`
    WHERE id_basket_header IS NULL
) new_element_staging_basket
WHERE staging_basket.id_store      = new_element_staging_basket.id_store
  AND staging_basket.id_cash_desk  = new_element_staging_basket.id_cash_desk
  AND staging_basket.id_customer   = new_element_staging_basket.id_customer
  AND staging_basket.purchase_date = new_element_staging_basket.purchase_date
;

/*
  Drop the temporary table. 
  If not dropped, it will simply be replaced in the next run 
  but stay clean, and remove it when finished. 
*/
DROP TABLE IF EXISTS `{{ project_id }}.staging.basket_temp`;
