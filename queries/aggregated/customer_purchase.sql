SELECT
  ANY_VALUE(customer.first_name)               AS `first_name`,
  ANY_VALUE(customer.last_name)                           AS `last_name`,
  COUNT(basket_header.id_basket_header)            AS `n_basket`,
  ROUND(SUM(basket_header.total_price), 2)        AS `total_purchase`,
  MAX(basket_header.purchase_date) AS `first_purchase_date`,
  MIN(basket_header.purchase_date)  AS `last_purchase_date`
FROM
  ## Bonne pratique: table la + grosse à gauche le plus opti
  `cleaned.customer` customer
  LEFT JOIN `cleaned.basket_header` basket_header ON customer.id_customer = basket_header.id_customer
GROUP BY
  customer.id_customer;