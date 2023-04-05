SELECT
  DATE(purchase_date)                  AS `day`,
  SUM(n_product)                       AS `total_product`,
  SUM(ROUND(total_price, 2))           AS `total_sale`,
FROM
  `{{ project_id }}.cleaned.basket_header`
GROUP BY day;