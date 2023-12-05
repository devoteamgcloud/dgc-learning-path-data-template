### S: raw.basket
-- id_cash_desk
-- id_customer
-- details
-- details.produ. ct_name
-- details.quantity
-- details.unit_price
-- payment_mode
-- purchase_date
-- update_time

### T: staging.basket
--> id_basket_header: incremental increase with ROW_NUMBER()
--> id_store: CAST(FIRST_PART(id_cash_desk) AS INT) -- FIRST_PART = TRIM + 
--> id_cash_desk: CAST(SECOND_PART(id_cash_desk) AS INT)
--> e.g. id_cash_desk: 00000012-00000789
    --> id_store: 12
    --> id_cash_desk: 789
-- id_customer
-- details
-- details.product_name
-- details.quantity
-- details.unit_price
-- payment_mode
-- purchase_date
-- update_time
--> insertion_time: NOW()

-- CREATE TABLE staging.basket_temp AS (
--   SELECT
--     NULL AS `id_basket_header`,
--     CAST(TRIM(SPLIT(id_cash_desk, "-")[0], "0") AS INT) AS id_store,
--     CAST(TRIM(SPLIT(id_cash_desk, "-")[1], "0") AS INT) AS id_cash_desk,
--     id_customer,
--     details,
--     payment_mode,
--     purchase_date,
--     update_time,
--     CURRENT_TIMESTAMP() AS `insertion_time`
--   FROM
--     `raw.basket`
-- );

MERGE staging.basket_temp AS T
USING (
  WITH deduplicated_detail AS (
    SELECT
      -- PK
      id_customer,
      id_cash_desk,
      purchase_date,
      -- details
      STRUCT(
          details.product_name AS product_name,
          SUM(details.quantity) AS quantity,
          ROUND(SUM(details.unit_price)/COUNT(details.product_name), 2) AS unit_price
        ) AS detail
    FROM
      staging.basket_temp,
      UNNEST(detail) AS details
    GROUP BY
      -- Group by PK & product_name to deduplicate
      id_store,
      id_customer,
      id_cash_desk,
      purchase_date,
      details.product_name
  )

  SELECT
    id_customer,
    id_cash_desk,
    purchase_date,
    ARRAY_AGG(detail) AS detail
  FROM
    deduplicated_detail
  GROUP BY   
    id_customer,
    id_cash_desk,
    purchase_date
) AS S
ON T.id_customer = S.id_customer AND S.id_cash_desk = T.id_cash_desk AND S.purchase_date = T.purchase_date
WHEN MATCHED THEN
  UPDATE SET
    T.detail = S.detail;