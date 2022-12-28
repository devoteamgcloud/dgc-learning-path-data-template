WITH basket_temp AS (
  /*
  * 1-1 basic transformation
  * generate id_basket_header with null value as default
  * apply deduplication 
  */
  SELECT 
  NULL                                                 AS `id_basket_header`,
  CAST(SPLIT(id_cash_desk,"-")[OFFSET(0)] AS INT)      AS `id_store`,
  CAST(SPLIT(id_cash_desk,"-")[OFFSET(1)] AS INT)      AS `id_cash_desk`,
  id_customer,
  -- consolidate the record by avoiding duplicate product name
  ARRAY(
    SELECT AS STRUCT
      product_name,
      SUM(quantity)                                    AS `quantity`,
      AVG(unit_price)                                  AS `unit_price`
    FROM UNNEST(detail)
    GROUP BY product_name
  ) detail,
  CASE LOWER(payment_mode)
    WHEN 'cash' THEN 'Cash'
    ELSE 'Card'
  END                                                  AS `payment_mode`,
  PARSE_DATETIME("%d-%m-%Y %H:%M:%S", purchase_date)   AS `purchase_date`,
  update_time,
  CURRENT_TIMESTAMP()                                  AS `insertion_time`, 
FROM `{{ project_id }}.raw.basket`
QUALIFY ROW_NUMBER() OVER(
  PARTITION BY
    id_store,
    id_cash_desk,
    id_customer,
    purchase_date
  ORDER BY
    update_time DESC
) = 1
), basket AS (
  /*
  * assign id to id_basket_header according to basket_header
  */
  SELECT
    cleaned_header.id_basket_header,
    id_store,
    id_cash_desk,
    id_customer,
    detail,
    basket_temp.payment_mode,
    purchase_date,
    basket_temp.update_time,
    basket_temp.insertion_time,
  FROM basket_temp 
  LEFT JOIN `{{ project_id }}.cleaned.basket_header` cleaned_header 
    USING(id_store, id_cash_desk, id_customer, purchase_date)
), maximum AS (
  /*
  * a view to get the max of id
  * 0 if there is no data 
  * else max of id_basket_header
  */
  SELECT
    CASE
      WHEN max(id_basket_header) IS NULL
      THEN 0 
      ELSE max(id_basket_header)
    END                                                 AS `max_id`,
  FROM `{{ project_id }}.cleaned.basket_header`
)
 
SELECT
  CASE 
    WHEN id_basket_header IS NULL
    -- increment only on call
    THEN ROW_NUMBER() OVER() + maximum.max_id
    ELSE id_basket_header
  END                                                   AS `id_basket_header`,
  id_store,
  id_cash_desk,
  id_customer,
  detail,
  payment_mode,
  purchase_date,
  update_time,
  insertion_time,
FROM basket, maximum
;