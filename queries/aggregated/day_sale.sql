SELECT
    EXTRACT(DATE FROM purchase_date) AS 'purchase_date' ,
    SUM(n_product) AS 'total_product',
    SUM(total_price) AS total_sale
FROM
  `{{ project_id }}.cleaned.basket_header`
GROUP BY
    1