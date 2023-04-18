SELECT
  first_name,
  last_name,
  COUNT(id_basket_header) AS `n_basket`,
  SUM(total_price) AS `total_purchase`,
  MIN(purchase_date) AS `first_purchase_date`,
  MAX(purchase_date) AS `last_purchase_date`
FROM `{{ project_id }}.cleaned.customer` AS customer
INNER JOIN `{{ project_id }}.cleaned.basket_header` AS basket_header
  ON customer.id_customer = basket_header.id_customer
GROUP BY
  first_name,
  last_name