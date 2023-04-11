SELECT 
  id_customer,
  first_name,
  last_name,
  email,
  PARSE_DATE("%d-%b-%y", creation_date)       AS `creation_date`,
  update_time,
  CURRENT_TIMESTAMP()                         AS `insertion_time`
FROM `{{ project_id }}.raw.customer`
QUALIFY ROW_NUMBER() OVER(   --regrouper par rapport à ce qu'il y a dans le "OVER"
    PARTITION BY             --regroupe par colonne, ici customer id car on veut empêcher les dédoublements
        id_customer
    ORDER BY
        update_time DESC --avec pour principe que le premier est le bon, et les autres des erreurs (enfin j'espère)
) = 1
;