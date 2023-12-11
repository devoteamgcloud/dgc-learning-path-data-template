## staging.basket
--> id_basket_header
--> id_store
--> id_cash_desk
--> id_customer
-- detail
-- detail.product_name
-- detail.quantity
-- detail.unit_price
-- payment_mode
--> purchase_date
--> update_time
--> insertion_time

##cleaned.basket_header
--> id_basket_header
--> id_store
--> id_cash_desk
--> id_customer
-- n_product: number of purchased products
-- n_product_distinct: number of distinct products purchased
-- total_price: total price of the basket
--> payment_mode
--> purchase_date
-- creation_time: time of record creation
--> update_time
--> insertion_time

MERGE INTO
  '{{ project_id }}.cleaned.basket_header' T USING '{{ project_id }}.staging.basket' S ON S.id_basket_header = T.id_basket_header
WHEN MATCHED AND T.update_time < S.update_time THEN
UPDATE SET
    T.id_basket_header = S.id_basket_header,
    T.id_store = T.id_store,
    T.id_cash_desk =T.id_cash_desk,
    T.id_customer = S.id_customer,
    T.n_product = S.n_product,
    T.n_product_distinct = S.n_product_distinct,
    T.total_price = S.total_price,
    T.payment_mode = S.payment_mode,
    T.purchase_date = S.purchase_date
    T.creation_time = S.creation_time,
    T.update_time = S.update_time,
    T.insertion_time = S.insertion_time
WHEN NOT MATCHED BY TARGET THEN
INSERT
  ROW;


