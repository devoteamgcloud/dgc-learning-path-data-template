MERGE
  `sandbox-avestu.cleaned.customer` T
USING
  `sandbox-avestu.staging.customer` S
ON
  T.id_customer = S.id_customer
  WHEN MATCHED THEN UPDATE SET 
  T.id_customer = S.id_customer,
    T.first_name = S.first_name,
    T.last_name = S.last_name,
    T.email = S.email,
    T.creation_date = S.creation_date,
    T.update_time = S.update_time,
    T.insertion_time = S.insertion_time
  WHEN NOT MATCHED BY TARGET THEN
INSERT
  (id_customer,
    first_name,
    last_name,
    email,
    creation_date,
    update_time,
    insertion_time)
VALUES
  (S.id_customer, S.first_name, S.last_name, S.email, S.creation_date, S.update_time, S.insertion_time);
