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

## TODO
-- staging.basket_temp:
    -- unnest all nested details
    -- deduplicate all nested details
    -- keep id_basket_header Null
    -- insertion_time == NOW()
-- staging basket:
    -- 
    
WITH staging.basket_temp AS (

)