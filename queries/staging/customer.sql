SELECT 
  id_customer,
  first_name,
  last_name,
  email,
  creation_date,
  update_time,
  CURRENT_TIMESTAMP()                      AS `insertion_time`
FROM (
  SELECT 
    id_customer,
    first_name,
    UPPER(last_name)                         AS `last_name`,
    email,
    PARSE_DATE("%d-%B-%y", creation_date)    AS `creation_date`,
    update_time,
    ROW_NUMBER() OVER (
      PARTITION BY id_customer 
      ORDER BY update_time DESC
    ) AS row_num
  FROM `sandbox-achaabene.raw.customer`
) AS subquery
WHERE row_num = 1;