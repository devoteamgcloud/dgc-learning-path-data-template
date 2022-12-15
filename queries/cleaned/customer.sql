MERGE `{{ project_id }}.cleaned.customer` AS Target
USING `{{ project_id }.staging.customer` AS Source
ON Source.id_customer = Target.id_customer

--For inserts
WHEN NOT MATCHED BY Target THEN
    INSERT (id_customer,
            first_name,
            last_name,
            email,
            creation_date,
            update_time,
            insertion_time)
    
    VALUES (Source.id_customer,
            Source.first_name,
            Source.last_name,
            Source.email,
            Source.creation_date,
            Source.update_time,
            CURRENT_TIMESTAMP())

--For updates
WHEN MATCHED THEN UPDATE SET
    Target.update_time = Source.update_time