## raw.basket
-- id_cash_desk
-- id_customer
-- detail
--> detail.product_name
--> detail.quantity
--> detail.unit_price
-- payment_mode
-- purchase_date
--> update_time

## staging.basket_detail
--# id_basket_header
--> product_name
--> quantity
--> unit_price
--> update_time
--# insertion_time

SELECT
  id_basket_header,
  product_name,
  quantity,
  unit_price,
  update_time,
  CURRENT_TIMESTAMP() AS `insertion_time`
FROM
  staging.basket,
  UNNEST(detail)