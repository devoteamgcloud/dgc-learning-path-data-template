SELECT
  first_name,
  last_name,
  COUNT(id_basket_header) AS n_basket,
  SUM(total_price) AS total_purchase,
  MIN(purchase_date) AS first_purchase_date,
  MAX(purchase_date) AS last_purchase_date
FROM
  `cleaned.customer`c
JOIN
  `cleaned.basket_header` b
ON
  c.id_customer=b.id_customer
GROUP BY
  c.id_customer, first_name, last_name;