SELECT 
  city                                       AS `city_store`,
  s.id_store,
  id_cash_desk,
  COUNT(id_customer)                         AS `n_basket`,
  SUM(n_product)                             AS `n_product`,
  ROUND(SUM(total_price),2)                  AS `total_price`
FROM `sandbox-ymarcel.cleaned.store`         AS s
JOIN `sandbox-ymarcel.cleaned.basket_header` AS b
ON s.id_store = b.id_store
GROUP BY city,s.id_store,id_cash_desk