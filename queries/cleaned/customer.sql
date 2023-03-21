MERGE `{{ project_id }}.cleaned.customer` T
USING `{{ project_id }}.staging.customer` S
ON T.id_customer = S.id_customer
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED BY TARGET INSERT ROW
