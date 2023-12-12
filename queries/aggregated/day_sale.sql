INSERT INTO
  `{{ project_id }}.aggregated.day_sale` (day, total_product, total_sale)
SELECT
  DATE(purchase_date) AS `day`,
  n_product           AS `total_product`,
  total_price         AS `total_sale`
FROM
  `{{ project_id }}.cleaned.basket_header`;