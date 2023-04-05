MERGE INTO `{{ project_id }}.cleaned.customer` T
USING `{{ project_id }}.staging.customer` S
  ON S.id_customer = T.id_customer
WHEN MATCHED AND T.update_time < S.update_time THEN  -- [MENTOR #2]
  UPDATE SET
    T.first_name     = S.first_name,
    T.last_name      = S.last_name,
    T.email          = S.email,
    T.update_time    = S.update_time,
    T.insertion_time = S.insertion_time
WHEN NOT MATCHED BY TARGET THEN 
  INSERT ROW
;
