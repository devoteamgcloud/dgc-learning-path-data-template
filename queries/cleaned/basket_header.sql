MERGE
  `{{ project_id }}.cleaned.basket_header` AS TARGET
USING
  (
  SELECT
    id_basket_header,
    id_store,
    id_cash_desk,
    id_customer,
    (
    SELECT
      SUM(d.quantity)
    FROM
      UNNEST(detail) d ) AS `n_product`,
    (
    SELECT
      COUNT(DISTINCT d.product_name)
    FROM
      UNNEST(detail) d ) AS `n_product_distinct`,
    (
    SELECT
      SUM(d.quantity * d.unit_price)
    FROM
      UNNEST(detail) d ) AS `total_price`,
    payment_mode,
    purchase_date,
    DATETIME(update_time) AS `creation_time`,
    update_time,
    insertion_time
  FROM
    `{{ project_id }}.staging.basket` ) AS SOURCE
ON
  SOURCE.id_basket_header = TARGET.id_basket_header
  WHEN MATCHED THEN UPDATE SET 
    TARGET.id_store = SOURCE.id_store,
    TARGET.id_cash_desk = SOURCE.id_cash_desk,
    TARGET.id_customer = SOURCE.id_customer,
    TARGET.n_product = SOURCE.n_product,
    TARGET.n_product_distinct = SOURCE.n_product_distinct,
    TARGET.total_price = SOURCE.total_price,
    TARGET.payment_mode = SOURCE.payment_mode,
    TARGET.purchase_date = SOURCE.purchase_date,
    TARGET.creation_time = SOURCE.creation_time,
    TARGET.update_time = SOURCE.update_time,
    TARGET.insertion_time = SOURCE.insertion_time
  WHEN NOT MATCHED BY TARGET
  THEN
INSERT
  ROW;