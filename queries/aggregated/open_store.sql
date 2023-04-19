SELECT
  city,
  country,
  coordinate,
  creation_date
FROM `{{ project_id }}.cleaned.store`
WHERE is_closed = false