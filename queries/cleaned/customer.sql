MERGE `{{ project_id }}.cleaned.customer` AS Target 
USING `{{ project_id }}.staging.customer` AS Source 
ON Source.id_customer = Target.id_customer
WHEN NOT MATCHED BY Target THEN
INSERT
  ROW
WHEN MATCHED THEN
  UPDATE SET
    Target.update_time = Source.update_time,
    Target.first_name = Source.first_name
    Target.last_name = Source.last_name
    Target.email = Source.email