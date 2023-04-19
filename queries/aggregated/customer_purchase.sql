SELECT
  first_name,
  last_name,
  COUNT(id_basket_header) AS `n_basket`,
  ROUND(SUM(total_price),2) AS `total_purchase`,
  MIN(purchase_date) AS `first_purchase_date`,
  MAX(purchase_date) AS `last_purchase_date`
FROM `cleaned.customer` AS customer
INNER JOIN `cleaned.basket_header` AS basket_header
  ON customer.id_customer = basket_header.id_customer
GROUP BY
  first_name,
  last_name