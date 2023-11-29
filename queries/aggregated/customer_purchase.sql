SELECT
  ANY_VALUE(customer.first_name)               AS `first_name`,
  ANY_VALUE(customer.last_name)                AS `last_name`,
  ANY_VALUE(basket_header.n_basket)                 AS `n_basket`,
  ROUND(b.total_purchase, 2) AS `total_purchase`,
  ANY_VALUE(basket_header.first_purchase_date)      AS `first_purchase_date`,
  ANY_VALUE(basket_header.last_purchase_date)       AS `last_purchase_date`
FROM
## Bonne pratique: table la + grosse à gauche le plus opti
  `cleaned.customer` customer
  LEFT JOIN `cleaned.basket_header` basket_header ON customer.id_customer = basket_header.id_customer
GROUP BY
  customer.id_customer