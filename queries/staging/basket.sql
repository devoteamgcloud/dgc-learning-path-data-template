WITH basket_temp AS (
  SELECT 
    CAST(SPLIT(id_cash_desk,'-')[SAFE_OFFSET(0)]   AS INTEGER)          AS `id_store`,
    CAST(SPLIT(id_cash_desk,'-')[SAFE_OFFSET(1)]   AS INTEGER)          AS `id_cash_desk`,
    id_customer,
    ARRAY(
      SELECT AS STRUCT
        product_name,
        SUM(quantity) AS `quantity`,
        SUM(unit_price*quantity)/SUM(quantity) AS `unit_price`, 
      FROM UNNEST(detail) AS detail
      GROUP BY product_name
    ) AS detail,
    CASE
      WHEN LOWER(payment_mode) = 'cash'
        THEN 'Cash'
      ELSE 'Card'
    END AS `payment_mode`,
    PARSE_DATETIME("%d-%m-%Y %H:%M:%S", purchase_date)             AS `purchase_date`,
    update_time,  
    CURRENT_TIMESTAMP()                                            AS `insertion_time`
    FROM `{{ project_id }}.raw.basket`
    QUALIFY ROW_NUMBER() OVER(   --regrouper par rapport à ce qu'il y a dans le "OVER"
      PARTITION BY             --regroupe par colonne, ici tous les id car on veut empêcher les dédoublements
        id_store,
        id_cash_desk,
        id_customer,
        purchase_date
      ORDER BY
        update_time DESC 
    ) = 1
), 

basket AS (
  SELECT
    data_set_basket_header.id_basket_header AS `id_basket_header`,
    basket_temp.* 
  FROM basket_temp
  LEFT JOIN `cleaned.basket_header` AS data_set_basket_header
    ON basket_temp.id_store = data_set_basket_header.id_store 
    AND basket_temp.id_cash_desk = data_set_basket_header.id_cash_desk
    AND basket_temp.id_customer = data_set_basket_header.id_customer
    AND basket_temp.purchase_date = data_set_basket_header.purchase_date
),

maximum AS (
  SELECT
    MAX(id_basket_header) AS `max_basket_id`
  FROM `{{ project_id }}.cleaned.basket_header`

)

SELECT
  COALESCE(basket.id_basket_header, maximum.max_basket_id + ROW_NUMBER() OVER(), ROW_NUMBER() OVER()) AS `id_basket_header`,
  basket.* EXCEPT(id_basket_header)

FROM basket CROSS JOIN maximum
;