-- INSERT INTO `{{ project_id }}.cleaned.store`
SELECT 
  CAST(id_store   AS INTEGER)              AS `id_store`,
  CAST(id_manager AS INTEGER)              AS `id_manager`,
  city,
  UPPER(country)                           AS `country`,
  ST_GEOGPOINT(x_coordinate, y_coordinate) AS `coordinate`,
  CASE UPPER(is_closed) 
    WHEN 'N' THEN False 
    WHEN 'Y' THEN True 
    ELSE NULL 
  END                                      AS `is_closed`,
  PARSE_DATE("%d-%m-%Y", creation_date)    AS `creation_date`,
  update_time,
  CURRENT_TIMESTAMP()                      AS `insertion_time`
FROM `{{ project_id }}.raw.store`;
