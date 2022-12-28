SELECT 
  city                                       AS `city_store`,
  store.id_store,
  id_cash_desk,
  COUNT(id_customer)                         AS `n_basket`,
  SUM(n_product)                             AS `n_product`,
  ROUND(SUM(total_price),2)                  AS `total_price`,
FROM `sandbox-ymarcel.cleaned.store`         AS store
JOIN `sandbox-ymarcel.cleaned.basket_header` AS basket_header
ON store.id_store = basket_header.id_store
GROUP BY 
    city,
    store.id_store,
    id_cash_desk
;