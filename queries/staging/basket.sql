WITH
  basket_temp AS(
  SELECT
    CAST(SPLIT(id_cash_desk, '-')[
    OFFSET
      (0)] AS INTEGER) AS id_store,
    CAST(SPLIT(id_cash_desk, '-') [
    OFFSET
      (1)] AS INTEGER) AS id_cash_desk,
    id_customer,
    product_name,
    SUM(quantity) AS quantity,
    AVG(unit_price) AS unit_price,
  IF
    (payment_mode="Cash", 'Cash', 'Card') AS payement_mode,
    PARSE_DATETIME('%d-%m-%Y %H:%M:%S', purchase_date) AS purchase_date,
    update_time,
    CURRENT_TIMESTAMP() AS insertion_time
  FROM
    raw.basket,
    UNNEST(detail) AS detail
  GROUP BY
    id_store,
    id_cash_desk,
    id_customer,
    product_name,
    payement_mode,
    purchase_date,
    update_time,
    insertion_time )
SELECT
  IFNULL(c.id_basket_header,IFNULL(MAX(c.id_basket_header),0) + ROW_NUMBER() OVER()) AS id_basket_header,
  t.id_store,
  t.id_cash_desk,
  t.id_customer,
  ARRAY_AGG(STRUCT(t.product_name,
      t.quantity,
      t.unit_price)) AS detail,
  t.payement_mode,
  t.purchase_date,
  t.update_time,
  t.insertion_time
FROM
  basket_temp AS t
LEFT OUTER JOIN
  cleaned.basket_header AS c
ON
  t.id_store=c.id_store
  AND t.id_cash_desk=c.id_cash_desk
  AND t.id_customer=c.id_customer
  AND t.purchase_date=c.purchase_date
GROUP BY
  c.id_basket_header,
  id_store,
  id_cash_desk,
  id_customer,
  payement_mode,
  purchase_date,
  update_time,
  insertion_time ;