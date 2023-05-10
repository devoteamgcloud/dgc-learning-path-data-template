-- start by creating a staging.basket_temp table with only the simple transformations from raw.basket (the transformations that are not specified just below). For now set id_basket_header to NULL.
-- then dedupicate the detail on product_name updating the staging.basket_temp table in place (really, really hard).
-- create staging.basket table joining with cleaned.basket_header table to retrieve existing basket headers ids and keep the new header AS NULL.
-- and update the staging.basket table in place to fill the NULL (new) basket headers with an incremental value starting from the last id known in the cleaned.basket_header table.
-- to be clean, delete the temporary table staging.basket_temp.
WITH basket_temp AS (
    ----------------------------PART 1-----------------------------------
    SELECT NULL                                               AS                                              `id_basket_header`,
           CAST(SPLIT(id_cash_desk, "-")[
               OFFSET
                   (0)] AS INT)                               AS                                              `id_store`,
           CAST(SPLIT(id_cash_desk, "-")[
               OFFSET
                   (1)] AS INT)                               AS                                              `id_cash_desk`,
           id_customer                                        AS                                              `id_customer`,
           ARRAY(
               SELECT
      AS STRUCT product_name, SUM(quantity) AS `quantity`, AVG(unit_price) AS `unit_price`
    FROM
      UNNEST(detail)
    GROUP BY
      product_name) detail,
           CASE LOWER(payment_mode)
               WHEN 'cash' THEN 'Cash'
               ELSE
                   'Card'
               END
                                                              AS                                              `payment_mode`,
           PARSE_DATETIME("%d-%m-%Y %H:%M:%S", purchase_date) AS                                              `purchase_date`,
           update_time,
           CURRENT_TIMESTAMP()                                AS                                              `insertion_time`,
    FROM `sandbox-sdiouf.raw.basket`
             ----------------------------PART 2-----------------------------------
             --  Here we will use deduplication using Qualifying by row number
             QUALIFY ROW_NUMBER() OVER(PARTITION BY id_store, id_cash_desk, id_customer, purchase_date ORDER BY update_time DESC ) = 1 ),
     ----------------------------PART 3-----------------------------------
    basket AS (
SELECT
    h.id_basket_header, id_store, id_cash_desk, id_customer, detail, b.payment_mode, purchase_date, b.update_time, b.insertion_time
FROM
    basket_temp b
    LEFT JOIN
    `sandbox-sdiouf.cleaned.basket_header` h
    USING
    (id_store, id_cash_desk, id_customer, purchase_date))
SELECT CASE
           WHEN id_basket_header IS NULL THEN ROW_NUMBER() OVER() + ( SELECT CASE
      WHEN MAX(id_basket_header) IS NULL THEN 0
    ELSE
    MAX(id_basket_header)
  END
    AS `max_id`,
  FROM
    `sandbox-sdiouf.cleaned.basket_header`)
           ELSE
               id_basket_header
           END
           AS `id_basket_header`,
       id_store,
       id_cash_desk,
       id_customer,
       detail,
       payment_mode,
       purchase_date,
       update_time,
       insertion_time,
FROM basket;