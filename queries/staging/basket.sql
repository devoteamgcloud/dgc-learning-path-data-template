### S: raw.basket
-- id_cash_desk
-- id_customer
-- detail
-- detail.product_name
-- detail.quantity
-- detail.unit_price
-- payment_mode
-- purchase_date
-- update_time

### T: staging.basket
--> id_basket_header: incremental increase with ROW_NUMBER()
--> id_store: CAST(FIRST_PART(id_cash_desk) AS INT) -- FIRST_PART = TRIM + 
--> id_cash_desk: CAST(SECOND_PART(id_cash_desk) AS INT)
--> e.g. id_cash_desk: 00000012-00000789
    --> id_store: 12
    --> id_cash_desk: 789
-- id_customer
-- detail
-- detail.product_name
-- detail.quantity
-- detail.unit_price
-- payment_mode
-- purchase_date
-- update_time
--> insertion_time: NOW()

INSERT INTO staging.basket``