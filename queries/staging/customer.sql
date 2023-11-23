SELECT
  CAST(id_customer AS INTEGER) AS 'id_customer',
  first_name,
  UPPER(last_name)             AS 'last_name',
  email,
  CAST(creation_date           AS DATE),
  update_time,
  CURRENT_TIMESTAMP()          AS 'insertion_time'
GROUP BY
  email
HAVING
  COUNT(email) > 1
FROM
  `{{ project_id }}.raw.customer`;