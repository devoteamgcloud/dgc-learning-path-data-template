SELECT
  CAST(id_customer AS INTEGER) AS 'id_customer',
  first_name,
  UPPER(last_name)             AS 'last_name',
  email,
  CAST(creation_date           AS DATE),
  update_time,
  CURRENT_TIMESTAMP()          AS 'insertion_time'
FROM
  `{{ project_id }}.raw.customer`
GROUP BY
  email
HAVING
  COUNT(email) = 1;