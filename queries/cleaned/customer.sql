MERGE INTO `{{ project_id }}.cleaned.customer` AS C
    USING `{{ project_id }}.staging.customer` AS S
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
        S.id_customer,
        S.first_name,
        S.last_name,
        S.email,
        S.creation_date,
        S.update_time,
        CURRENT_TIMESTAMP()
        )

    WHEN MATCHED AND Staging.update_time > Cleaned.update_time --S'il y a des updates plus récentes, on update la Target

        UPDATE SET 
            C.id_customer = S.id_customer
            C.first_name = S.first_name
            C.last_name = S.last_name
            C.email = S.email
            C.creation_date = S.creation_date
            C.update_time = S.update_time
            C.insertion_time = CURRENT_TIMESTAMP()
