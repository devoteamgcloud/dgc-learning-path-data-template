SELECT
  id_cash_desk,
  d.product_name AS product_name,
  d.quantity AS quantity,
  d.unit_price AS unit_price,
  update_time,
  CURRENT_TIMESTAMP() AS insertion_time
FROM
  `sandbox-avestu.raw.basket`,
  UNNEST(detail) AS d;