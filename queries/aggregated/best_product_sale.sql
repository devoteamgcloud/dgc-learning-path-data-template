SELECT
  product_name,
  RANK() OVER(ORDER BY SUM(quantity) DESC) AS `rank_in_quantity`,
  RANK() OVER(ORDER BY ROUND(SUM(quantity)*unit_price, 2) DESC) AS `rank_in_sale`,
  SUM(quantity) AS `total_quantity`,
  ROUND(SUM(quantity)*unit_price, 2) AS `total_sale`
  FROM `{{ project_id }}.cleaned.basket_detail`
GROUP BY
  product_name,
  unit_price