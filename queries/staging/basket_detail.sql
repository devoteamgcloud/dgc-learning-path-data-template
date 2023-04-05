SELECT 
  id_basket_header,
  detail.product_name,
  detail.quantity,
  detail.unit_price,
  update_time,
  insertion_time,
FROM 
  `{{ project_id }}.staging.basket`
  CROSS JOIN UNNEST(detail) detail
;
