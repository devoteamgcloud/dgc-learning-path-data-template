CREATE TEMP TABLE basket_header_temp
AS
  SELECT 
    id_basket_header,
    SUM(quantity)            AS `n_product`,
    COUNT(product_name)         AS `n_product_distinct`,
    ROUND(SUM(unit_price*quantity),2) AS `total_price`
  FROM `{{ project_id }}.staging.basket` AS basket, UNNEST(detail) AS details
  GROUP BY
    id_basket_header
  ORDER BY
    id_basket_header
;


MERGE INTO `{{ project_id }}.cleaned.basket_header` AS Cleaned
  USING (
    SELECT
      basket.id_basket_header, 
      basket.id_store, 
      basket.id_cash_desk, 
      basket.id_customer,
      basket_header_temp.n_product,
      basket_header_temp.n_product_distinct,
      basket_header_temp.total_price,
      basket.payment_mode, 
      basket.purchase_date, 
      basket.update_time, 
      basket.update_time AS `creation_time`,
      basket.insertion_time
    FROM `{{ project_id }}.staging.basket` AS basket
    LEFT JOIN basket_header_temp
      ON basket.id_basket_header = basket_header_temp.id_basket_header --USING(id_basket_header)
  ) AS Staging
  ON  Staging.id_basket_header = Cleaned.id_basket_header

  WHEN NOT MATCHED BY TARGET THEN
    INSERT ROW
  WHEN MATCHED AND Staging.update_time > Cleaned.update_time 
    THEN
      UPDATE SET 
        Cleaned.id_basket_header = Staging.id_basket_header, 
        Cleaned.id_store = Staging.id_store,
        Cleaned.id_cash_desk = Staging.id_cash_desk, 
        Cleaned.id_customer = Staging.id_customer,
        Cleaned.n_product = Staging.n_product,
        Cleaned.n_product_distinct = Staging.n_product_distinct,
        Cleaned.total_price = Staging.total_price,
        Cleaned.payment_mode = Staging.payment_mode, 
        Cleaned.purchase_date = Staging.purchase_date, 
        Cleaned.update_time = Staging.update_time, 
        Cleaned.insertion_time = Staging.insertion_time
;

DROP TABLE basket_header_temp;

