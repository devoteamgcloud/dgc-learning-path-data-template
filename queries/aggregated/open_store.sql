SELECT
  city,
  country,
  coordinate,
  creation_date
WHERE
  is_closed = "N"
FROM
  `{{ project_id }}.cleaned.store`