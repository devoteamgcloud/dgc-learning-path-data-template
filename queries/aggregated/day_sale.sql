SELECT
  CAST(purchase_date AS DATE) AS `day`,
  SUM(n_product) AS `total_product`,
  ROUND(SUM(total_price), 2) AS `total_sale`
FROM `{{ project_id }}.cleaned.basket_header`
GROUP BY
  day