MERGE
  `sandbox-avestu.cleaned.basket_detail` T
USING
  `sandbox-avestu.staging.basket_detail` S
ON
  T.id_basket_header=S.id_basket_header
  WHEN MATCHED THEN UPDATE SET 
  T.id_basket_header=S.id_basket_header, 
  T.product_name=S.product_name, 
  T.quantity=S.quantity,
  T.unit_price=S.unit_price, 
  T.update_time=S.update_time, 
  T.insertion_time=S.insertion_time
  WHEN NOT MATCHED BY TARGET
  THEN
INSERT
  (id_basket_header,
    product_name,
    quantity,
    unit_price,
    update_time,
    insertion_time)
VALUES
  (S.id_basket_header, S.product_name, S.quantity, S.unit_price, S.update_time, S.insertion_time);