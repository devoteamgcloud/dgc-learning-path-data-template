WITH customer_basket_kpis AS (
  /*
    Computes for each customer the
      - tumber of basket
      - total purchase
      - first purchase date
      - last purchase date
  */
  SELECT
    id_customer,
    COUNT(id_basket_header)    AS `n_basket`,
    ROUND(SUM(total_price), 2) AS `total_purchase`,
    MIN(purchase_date)         AS `first_purchase_date`,
    MAX(purchase_date)         AS `last_purchase_date`,
  FROM `cleaned.basket_header`
  GROUP BY 
    id_customer
)
/*
  Do NOT show names and other PII. 
  Instead, hash this information at least. 
*/
SELECT
  MD5(CONCAT(customer.first_name, customer.last_name)) AS `user_hashed`,
  -- customer.first_name,
  -- customer.last_name,
  basket_kpis.n_basket,
  basket_kpis.total_purchase,
  basket_kpis.first_purchase_date,
  basket_kpis.last_purchase_date,
FROM 
  `cleaned.customer` customer
  INNER JOIN `customer_basket_kpis` basket_kpis USING(id_customer)
;
