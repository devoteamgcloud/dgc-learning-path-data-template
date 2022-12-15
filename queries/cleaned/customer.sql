MERGE `{{ project_id }}.cleaned.customer` AS T
USING `{{ project_id }}.staging.customer` AS S
ON S.id_customer = T.id_customer

--For inserts
WHEN NOT MATCHED BY Target THEN
    INSERT (
      id_customer,
      first_name,
      last_name,
      email,
      creation_date,
      update_time,
      insertion_time
    )
    
    VALUES (
      S.id_customer,
      S.first_name,
      S.last_name,
      S.email,
      S.creation_date,
      S.update_time,
      CURRENT_TIMESTAMP()
    )

--For updates
WHEN MATCHED THEN UPDATE SET
  T.first_name = S.first_name,
  T.last_name = S.last_name,
  T.email = S.email,
  T.creation_date = S.creation_date,
  T.update_time = S.update_time,
  T.insertion_time = CURRENT_TIMESTAMP()