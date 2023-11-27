SELECT
  DATE(purchase_date),
  n_product           AS 'total_product',
  total_price         AS total_sale
FROM
  `{{ project_id }}.cleaned.basket_header`