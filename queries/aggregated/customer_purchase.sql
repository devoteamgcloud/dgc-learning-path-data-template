SELECT
  MD5(
    CONCAT(
      ANY_VALUE(customer.first_name),
      ANY_VALUE(customer.last_name)
    )
  )                                       AS `user`,
  COUNT(basket_header.id_basket_header)   AS `n_basket`,
  ROUND(SUM(basket_header.total_price),2) AS `total_purchase`,
  MIN(basket_header.purchase_date)        AS `first_purchase_date`,
  MAX(basket_header.purchase_date)        AS `last_purchase_date`,
FROM `sandbox-ymarcel.cleaned.customer`              customer
INNER JOIN `sandbox-ymarcel.cleaned.basket_header`   basket_header
ON customer.id_customer = basket_header.id_customer
GROUP BY customer.id_customer
;