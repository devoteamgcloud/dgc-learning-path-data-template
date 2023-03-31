  -- MERGE <target table> [AS TARGET]
  -- USING <source table> [AS SOURCE]
  -- ON <search_condition>
  -- [WHEN MATCHED
  -- THEN <merge the matched records> ]
  -- [WHEN NOT MATCHED [BY TARGET]
  -- THEN <perform merge operations when matching record is not found in the target table> ]
  -- [WHEN NOT MATCHED BY SOURCE
  -- THEN <perform merge operations when matching record is not found in the source table> ];
MERGE
  `{{ project_id }}.cleaned.customer` AS TARGET
USING
  `{{ project_id }}.staging.customer` AS SOURCE
ON
  Source.id_customer = Target.id_customer
  WHEN NOT MATCHED BY TARGET THEN INSERT (id_customer, first_name, last_name, email, creation_date, update_time, insertion_time) VALUES (Source.id_customer, Source.first_name, Source.last_name, Source.email, Source.creation_date, Source.update_time, Source.insertion_time)
  WHEN MATCHED
  THEN
UPDATE
SET
  Target.update_time = Source.update_time;