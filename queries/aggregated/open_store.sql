SELECT
  city,
  country,
  coordinate,
  creation_date
WHERE
  is_closed = FALSE
FROM
  `{{ project_id }}.cleaned.store`