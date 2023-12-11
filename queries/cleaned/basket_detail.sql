MERGE INTO
  '{{ project_id }}.cleaned.basket_detail' T USING '{{ project_id }}.staging.basket_detail' S ON S.id_basket_header = T.id_basket_header AND S.product_name = T.product_name
WHEN MATCHED AND T.update_time < S.update_time THEN
UPDATE SET
    T.id_basket_header = S.id_basket_header,
    T.product_name = T.product_name,
    T.creation_time = S.creation_time,
    T.update_time = S.update_time,
    T.quantity = S.quantity,
    T.unit_price = S.unit_price
WHEN NOT MATCHED BY TARGET THEN
INSERT
  ROW;