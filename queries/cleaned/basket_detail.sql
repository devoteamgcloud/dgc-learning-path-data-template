MERGE
  `{{ project_id }}.cleaned.basket_detail` AS TARGET
USING
  `{{ project_id }}.staging.basket_detail` AS SOURCE
ON
  TRUE
  AND Source.id_basket_header = Target.id_basket_header
  AND Source.product_name = Target.product_name
  WHEN NOT MATCHED BY TARGET THEN INSERT ( id_basket_header, product_name, quantity, unit_price, creation_time, update_time ) VALUES ( Source.id_basket_header, Source.product_name, Source.quantity, Source.unit_price, Source.update_time, Source.update_time )
  WHEN MATCHED
  THEN
UPDATE
SET
  Target.quantity = Source.quantity,
  Target.unit_price = Source.unit_price,
  Target.creation_time = Source.update_time,
  Target.update_time = Source.update_time ;