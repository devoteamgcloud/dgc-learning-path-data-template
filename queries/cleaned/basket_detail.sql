MERGE `{{ project_id }}.cleaned.basket_detail`        AS T
USING `{{ project_id }}.staging.basket_detail`        AS S
ON (
  S.id_basket_header = T.id_basket_header
  AND
  S.product_name     = T.product_name
)
-- For inserts
WHEN NOT MATCHED BY TARGET THEN
  INSERT(
    id_basket_header,
    product_name,
    creation_time,
    update_time,
    quantity,
    unit_price
  )
  VALUES(
    S.id_basket_header,
    S.product_name,
    S.update_time,
    S.update_time,
    S.quantity,
    S.unit_price
  )

-- For updates
WHEN MATCHED THEN UPDATE SET
  T.creation_time  = S.update_time,
  T.update_time    = S.update_time,
  T.quantity       = S.quantity,
  T.unit_price     = S.unit_price
