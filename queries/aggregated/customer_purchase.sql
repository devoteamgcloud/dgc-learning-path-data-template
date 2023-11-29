SELECT
  c.first_name               AS `first_name`,
  c.last_name                AS `last_name`,
  b.n_basket                 AS `n_basket`,
  ROUND(b.total_purchase, 2) AS `total_purchase`,
  b.first_purchase_date      AS `first_purchase_date`,
  b.last_purchase_date       AS `last_purchase_date`
FROM
  `{{ project_id }}.cleaned.customer` c
  LEFT JOIN `{{ project_id }}.cleaned.basket_header` b ON c.id_customer = b.id_customer
GROUP BY
  c.id_customer