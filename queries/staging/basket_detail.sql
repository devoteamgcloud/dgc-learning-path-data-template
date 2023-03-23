SELECT
  id_basket_header,
  d.product_name AS product_name,
  d.quantity AS quantity,
  d.unit_price AS unit_price,
  update_time,
  CURRENT_TIMESTAMP() AS insertion_time
FROM
  `sandbox-avestu.staging.basket`,
  UNNEST(detail) AS d;