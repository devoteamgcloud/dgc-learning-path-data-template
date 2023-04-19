SELECT
  city,
  country,
  coordinate,
  creation_date
FROM `cleaned.store`
WHERE is_closed = false;