SELECT 
  basket.id_basket_header,
  detail.product_name,
  detail.quantity,
  detail.unit_price,
  basket.update_time,
  basket.insertion_time

FROM `{{ project_id }}.staging.basket` AS basket, UNNEST(basket.detail) AS detail