SELECT
  id_basket_header,
  detail.product_name,
  detail.quantity,
  detail.unit_price,
  update_time,
  CURRENT_TIMESTAMP()         AS `insertion_time`
FROM `{{ project_id }}.staging.basket`, UNNEST(detail) detail
ORDER BY id_basket_header ASC