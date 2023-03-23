MERGE
  `sandbox-avestu.cleaned.basket_header` T
USING
  (
  SELECT
    id_basket_header,
    id_store,
    id_cash_desk,
    id_customer,
    SUM(quantity) AS n_product,
    APPROX_COUNT_DISTINCT(product_name) AS n_product_distinct,
    SUM(quantity*unit_price)AS total_price,
    payement_mode,
    purchase_date,
    update_time,
    insertion_time
  FROM
    `sandbox-avestu.staging.basket`,
    UNNEST(detail) AS d
  GROUP BY
    id_basket_header,
    id_store,
    id_cash_desk,
    id_customer,
    payement_mode,
    purchase_date,
    update_time,
    insertion_time ) S
ON
  T.id_basket_header=S.id_basket_header
  WHEN MATCHED THEN UPDATE SET 
  T.id_basket_header=S.id_basket_header, 
  T.id_store=S.id_store, 
  T.id_cash_desk=S.id_cash_desk, 
  T.id_customer=S.id_customer, 
  T.n_product=S.n_product, 
  T.n_product_distinct=S.n_product_distinct, 
  T.total_price=S.total_price, 
  T.payment_mode=S.payement_mode, 
  T.purchase_date=S.purchase_date, 
  T.creation_time=CAST(S.update_time AS DATETIME), 
  T.update_time=S.update_time, 
  T.insertion_time=S.insertion_time
  WHEN NOT MATCHED BY TARGET
  THEN
INSERT
  (id_basket_header,
    id_store,
    id_cash_desk,
    id_customer,
    n_product,
    n_product_distinct,
    total_price,
    payment_mode,
    purchase_date,
    creation_time,
    update_time,
    insertion_time)
VALUES
  (S.id_basket_header, S.id_store, S.id_cash_desk, S.id_customer, S.n_product, S.n_product_distinct, S.total_price, S.payement_mode, S.purchase_date, CAST(S.update_time AS DATETIME), S.update_time, S.insertion_time);