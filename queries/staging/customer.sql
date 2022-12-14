SELECT
    id_customer,
    first_name,
    UPPER(last_name)                            AS `last_name`,
    email,
    PARSE_DATED("%d-%m-%Y", creation_date)      AS `creation_date`,
    update_time,
    CURRENT_TIMESTAMP()                         AS `insertion_time`
FROM `{{ project_id }}.raw.customer`;