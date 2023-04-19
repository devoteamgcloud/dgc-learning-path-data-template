SELECT 
  basket.id_basket_header,
  detail.product_name,
  detail.quantity,
  detail.unit_price,
  basket.update_time,
  basket.insertion_time

FROM `{{ project_id }}.staging.basket` AS basket 
CROSS JOIN UNNEST(basket.detail) AS detail
ORDER BY basket.id_basket_header