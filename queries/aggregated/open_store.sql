SELECT
  city,
  country,
  ST_AsText(coordinate) as coordinate,
  MAX(creation_date) AS latest_creation_date
FROM
  `sandbox-achaabene.cleaned.store`
GROUP BY
  city, country, ST_AsText(coordinate)
