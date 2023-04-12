MERGE INTO `{{ project_id }}.cleaned.customer` AS Cleaned
    USING `{{ project_id }}.staging.customer` AS Staging
    ON Staging.id_customer = Cleaned.id_customer

    --Si ça n'existe pas, on l'ajoute avec un nouvel 'insertion_time' évidemment
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
        Staging.id_customer,
        Staging.first_name,
        Staging.last_name,
        Staging.email,
        Staging.creation_date,
        Staging.update_time,
        CURRENT_TIMESTAMP()
        )

    WHEN MATCHED AND Staging.update_time > Cleaned.update_time --S'il y a des updates plus récentes, on update la Target

        UPDATE SET 
            Cleaned.id_customer = Staging.id_customer
            Cleaned.first_name = Staging.first_name
            Cleaned.last_name = Staging.last_name
            Cleaned.email = Staging.email
            Cleaned.creation_date = Staging.creation_date
            Cleaned.update_time = Staging.update_time
            Cleaned.insertion_time = CURRENT_TIMESTAMP()
