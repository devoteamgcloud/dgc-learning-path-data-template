MERGE INTO `{{ project_id }}.cleaned.basket_detail` AS Cleaned
  USING (
    SELECT
      basket_detail.id_basket_header,
      basket_detail.product_name,
      basket_detail.update_time AS `creation_time`,
      basket_detail.update_time,
      basket_detail.quantity,
      basket_detail.unit_price
      
    FROM `{{ project_id }}.staging.basket_detail` AS basket_detail
  ) AS Staging
  ON  Staging.id_basket_header = Cleaned.id_basket_header

  WHEN NOT MATCHED BY TARGET THEN
    INSERT ROW
  WHEN MATCHED AND Staging.update_time > Cleaned.update_time --On update tout sauf creation_time évidemment
    THEN
      UPDATE SET 
        Cleaned.id_basket_header = Staging.id_basket_header, 
        Cleaned.product_name = Staging.product_name,
        Cleaned.update_time = Staging.update_time, 
        Cleaned.quantity = Staging.quantity,
        Cleaned.unit_price = Staging.unit_price
;