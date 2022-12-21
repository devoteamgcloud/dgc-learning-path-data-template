MERGE `{{ project_id }}.cleaned.basket_header`               AS T
USING ( 
  SELECT
    id_basket_header,
    id_store,
    id_cash_desk,
    id_customer,
    SUM(detail.quantity)                    AS `n_product`,
    COUNT(DISTINCT detail.product_name)     AS `n_product_distinct`,
    SUM(detail.unit_price)                  AS `total_price`,
    payment_mode,
    purchase_date,
    update_time,
    insertion_time
  FROM `{{ project_id }}.staging.basket`, UNNEST(detail) detail
  GROUP BY 
    id_basket_header,
    id_store, 
    id_cash_desk, 
    id_customer,
    payment_mode,
    purchase_date,
    update_time,
    insertion_time
)                                           AS S
ON S.id_basket_header = T.id_basket_header
-- For inserts
WHEN NOT MATCHED BY TARGET THEN
  INSERT (
    id_basket_header,
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
    insertion_time
  )
  VALUES(
    S.id_basket_header,
    S.id_store,
    S.id_cash_desk,
    S.id_customer,
    S.n_product,
    S.n_product_distinct,
    S.total_price,
    S.payment_mode,
    S.purchase_date,
    DATETIME(S.update_time,"Europe/Paris"),
    S.update_time,
    CURRENT_TIMESTAMP()
  )

-- For updates
WHEN MATCHED THEN UPDATE SET
  T.id_store           = S.id_store,
  T.id_cash_desk       = S.id_cash_desk,
  T.id_customer        = S.id_customer,
  T.n_product          = S.n_product,
  T.n_product_distinct = S.n_product_distinct,
  T.total_price        = S.total_price,
  T.payment_mode       = S.payment_mode,
  T.purchase_date      = S.purchase_date,
  T.creation_time      = DATETIME(S.update_time,"Europe/Paris"),
  T.update_time        = S.update_time,
  T.insertion_time     = CURRENT_TIMESTAMP()