MERGE `{{ project_id}}.cleaned.basket_detail` AS Target
USING `{{ project_id}}.staging.basket_detail` AS Source
ON Source.id_basket_header = Target.id_basket_header
WHEN NOT MATCHED BY Target THEN
    INSERT (
    id_basket_header,
    product_name,
    quantity,
    unit_price,
    creation_time,                 
    update_time                
            )
    VALUES (
    Source.id_basket_header,
    Source.product_name,
    Source.quantity,
    Source.unit_price,
    Source.update_time,
    Source.update_time 
            )
WHEN MATCHED THEN UPDATE SET
    Target.id_basket_header = Source.id_basket_header,
    Target.product_name = Source.product_name,
    Target.quantity = Source.quantity,
    Target.unit_price = Source.unit_price,
    Target.creation_time = Source.update_time,
    Target.update_time = Source.update_time