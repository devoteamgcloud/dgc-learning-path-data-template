SELECT
  MD5(
    CONCAT(
      ANY_VALUE(C.first_name),
      ANY_VALUE(C.last_name)
    )
  )                                  AS `user`,
  COUNT(B.id_basket_header)          AS `n_basket`,
  ROUND(SUM(B.total_price),2)        AS `total_purchase`,
  MIN(B.purchase_date)               AS `first_purchase_date`,
  MAX(B.purchase_date)               AS `last_purchase_date`
FROM `sandbox-ymarcel.cleaned.customer`              AS C
INNER JOIN `sandbox-ymarcel.cleaned.basket_header`   AS B
ON C.id_customer = B.id_customer
GROUP BY C.id_customer