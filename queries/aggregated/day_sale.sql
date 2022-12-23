SELECT
  DATE(purchase_date)     AS `day`,
  n_product               AS `total_product`,
  ROUND(total_price, 2)   AS `total_sale`
FROM `{{ project_id }}.cleaned.basket_header`