-- SELECT
--   product_name,
--   RANK() OVER (ORDER BY SUM(quantity) DESC) AS `rank_in_quantity`,
--   RANK() OVER (ORDER BY ROUND(SUM(quantity * unit_price)) DESC) AS `rank_in_sale`,
--   SUM(quantity) AS `total_quantity`,
--   ROUND(SUM(quantity * unit_price),2) AS `total_sales`,
-- FROM
--   `{{ project_id }}.cleaned.basket_detail`


WITH
  best_product_sale AS(
  SELECT
    product_name,
    SUM(quantity)                                   AS `total_quantity`,
    ROUND(SUM(quantity * unit_price),2)             AS `total_sales`,
  FROM
    `{{ project_id }}.cleaned.basket_detail`
  GROUP BY
    product_name )
SELECT
  product_name,
  RANK() OVER (ORDER BY total_quantity DESC)        AS `rank_in_quantity`,
  RANK() OVER (ORDER BY total_sales DESC)           AS `rank_in_sale`,
  total_quantity,
  total_sales,
FROM
  best_product_sale ;