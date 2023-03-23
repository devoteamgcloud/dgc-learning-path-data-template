SELECT
  CONCAT(
      ANY_VALUE(customer.first_name),
      ANY_VALUE(customer.last_name)
      )                                               as `customer_full_name`,
  COUNT(basket_header.id_basket_header)               as `n_basket`,
  ROUND(SUM(basket_header.total_price),2)             as `total_purchase`,
  MIN(basket_header.purchase_date)                    as `first_purchase_date`,
  MAX(basket_header.purchase_date)                    as `last_purchase_date`,
FROM `{{ project_id }}.cleaned.customer`              customer
INNER JOIN `{{ project_id }}.cleaned.basket_header`   basket_header
ON customer.id_customer = basket_header.id_customer
GROUP BY customer.id_customer
;