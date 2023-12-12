CREATE OR REPLACE VIEW
  `aggregated.open_store` AS (
    SELECT
      city,
      country,
      coordinate,
      creation_date
    FROM
      `cleaned.store`
    WHERE
      is_closed = FALSE
  )