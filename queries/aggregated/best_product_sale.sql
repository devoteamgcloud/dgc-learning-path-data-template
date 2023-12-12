INSERT INTO
  `{{ project_id }}.aggregated.best_product_sale` (
    product_name,
    rank_in_quantity,
    rank_in_sale,
    total_quantity,
    total_sale
  )
WITH
  aggregated_data AS (
    SELECT
      product_name,
      SUM(quantity)              AS `total_quantity`,
      SUM(unit_price * quantity) AS `total_sale`
    FROM
      `{{ project_id }}.cleaned.basket_detail`
    GROUP BY
      product_name
  )
SELECT
  product_name,
  DENSE_RANK() OVER (
    ORDER BY
      total_quantity DESC
  ) AS `rank_in_quantity`,
  DENSE_RANK() OVER (
    ORDER BY
      total_sale DESC
  ) AS `rank_in_sale`,
  total_quantity,
  total_sale
FROM
  aggregated_data;