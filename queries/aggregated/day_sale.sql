SELECT
  CAST(purchase_date AS DATE) AS day,
  SUM(n_product) AS total_product,
  ROUND(SUM(total_price), 4)AS total_sales,
FROM
  `sandbox-avestu.cleaned.basket_header`
  GROUP BY day