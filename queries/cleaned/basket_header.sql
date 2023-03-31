MERGE
  `{{ project_id }}.cleaned.basket_header` AS TARGET
USING
  (
  SELECT
    ( id_basket_header,
      id_store,
      id_cash_desk,
      id_customer,
      (
      SELECT
        SUM(d.quantity)
      FROM
        UNNEST(detail) d) AS `n_product`,
      (
      SELECT
        COUNT(DISTINCT d.product_name)
      FROM
        UNNEST(detail) d) AS `n_product_distinct`,
      (
      SELECT
        SUM(d.quantity * d.unit_price)
      FROM
        UNNEST(detail) d) AS `total_price`,
      payment_mode,
      purchase_date,
      DATETIME(update_time) AS `creation_time`,
      update_time insertion_time )
  FROM
    `{{ project_id }}.staging.basket_header` ) AS SOURCE
ON
  S.id_basket_header = T.id_basket_header
  WHEN MATCHED THEN UPDATE SET THEN T.id_store = S.id_store, T.id_cash_desk = S.id_cash_desk, T.id_customer = S.id_customer, T.n_product = S.n_product, T.n_product_distinct = S.n_product_distinct, T.total_price = S.total_price, T.payment_mode = S.payment_mode, T.purchase_date = S.purchase_date, T.creation_time = S.creation_time, T.update_time = S.update_time, T.insertion_time = S.insertion_time
  WHEN NOT MATCHED BY TARGET
  THEN
INSERT
  ROW