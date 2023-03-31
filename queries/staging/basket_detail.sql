-- https://cloud.google.com/bigquery/docs/reference/standard-sql/arrays

SELECT
    id_basket_header
    detail.product_name
    detail.quantity
    detail.unit_price
    update_time
    CURRENT_TIMESTAMP()                     as `insertion_time`
FROM `{{ project_id }}.staging.basket`
CROSS JOIN UNNEST(detail) AS detail;