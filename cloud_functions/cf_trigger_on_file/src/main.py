import os
import datetime
from google.cloud import storage
from google.cloud import pubsub_v1

# This dictionary gives your the requirements and the specifications of the kind
# of files you can receive. 
#     - the keys are the names of the files
#     - the values give the required extension for each file 

FILES_AND_EXTENSION_SPEC = {
    'store': 'csv',
    'customer': 'csv',
    'basket': 'json'
}

def hello_gcs(event, context):
    """Background Cloud Function to be triggered by Cloud Storage.
       This generic function logs relevant data when a file is changed.
    Args:
        event (dict):  The dictionary with data specific to this type of event.
                       The `data` field contains a description of the event in
                       the Cloud Storage `object` format described here:
                       https://cloud.google.com/storage/docs/json_api/v1/objects#resource
        context (google.cloud.functions.Context): Metadata of triggering event.
    Returns:
        None; the output is written to Stackdriver Logging
    """
    print('Event ID:' , context.event_id)
    print('Event type:', context.event_type)
    print('Bucket:', event['bucket'])
    print('File:',  event['name'])
    print('Metageneration:',  event['metageneration'])
    print('Created:',  event['timeCreated'])
    print('Updated:',  event['updated'])

def check_file_format(event: dict, context: dict):
    """
    Triggered by a change to a Cloud Storage bucket.
    Check for the files requirements. Publishes a message to PubSub if the 
    file is verified else movs the files to the invalid/ subfolder.

    Args:
         event (dict): Event payload. 
                       https://cloud.google.com/storage/docs/json_api/v1/objects#resource-representations
         context (google.cloud.functions.Context): Metadata for the event.
    """

    # rename the variable to be more specific and write it to the logs
    blob_event = event
    print(f'Processing blob: {blob_event["name"]}.')

    # get the bucket name and the blob path
    bucket_name = blob_event['bucket']
    blob_path = blob_event['name']

    # get the subfolder, the file name and its extension
    *subfolder, file = blob_path.split(os.sep)  
    subfolder =  os.path.join(*subfolder) if subfolder != [] else ''
    file_name, file_extention = file.split('.') 

    print(f'Bucket name: {bucket_name}')
    print(f'File path: {blob_path}')
    print(f'Subfolder: {subfolder}')
    print(f'Full file name: {file}')
    print(f'File name: {file_name}')
    print(f'File Extension: {file_extention}')

    # Check if the file is in the subfolder `input/` to avoid infinite loop
    assert subfolder == 'input', 'File must be in `input/ subfolder to be processed`'
    
    # check if the file name has the good format
    # required format: <table_name>_<date>.<extension>
    try:
        # TODO: 
        # create some assertions here to validate your file. It is:
        #     - required to have two parts.
        #     - the first part is required to be an accepted table name
        #1:
        prefix= file_name.split("_")[0] #we retrieve first part 
        suffix= file_name.split("_")[1] #we retrieve the date
        
        assert prefix in FILES_AND_EXTENSION_SPEC.keys(), "Table name not accepted"
            
        #2:  - the second part is required to be a 'YYYYMMDD'-formatted date  
        try:
            datetime.datetime.strptime(suffix, '%Y%m%d')
        except:
            raise Exception(f"{file_name} does not have the right format : YYYYMMDD")

        ...  
        #     - required to have the expected extension
        #3: we assign the extension according to the prefix
        assert file_extention in FILES_AND_EXTENSION_SPEC[prefix], "File extension not correct"
        

        table_name = prefix

        # if all checks are succesful then publish it to the PubSub topic
        publish_to_pubsub(
            data=table_name.encode('utf-8'),
            attributes={
                'bucket_name': bucket_name, 
                'blob_path': blob_path
            }
        )

    except Exception as e:
        print(e)
        # the file is moved to the invalid/ folder if one check is failed
        move_to_invalid_file_folder(bucket_name, blob_path)


def publish_to_pubsub(data: bytes, attributes: dict):
    """
    Publish a message to the pubsub topic to insert the file.

    Args:
         data (bytes): Encoded string as data for the message.
         attributes (dict): Custom attributes for the message.
    """
    ## this small part is here to be able to simulate the function but
    ## remove this part when you are ready to deploy your Cloud Function. 
    ## [start simulation]
    #print('Your file is considered as valid. It will be published to Pubsub.')
    r#eturn
    ## [end simulation]


    # retrieve the GCP_PROJECT from the reserved environment variables
    # more: https://cloud.google.com/functions/docs/configuring/env-var#python_37_and_go_111
    project_id = os.environ['GCP_PROJECT']
    topic_id = os.environ['pubsub_topic_id']
    
    # connect to the PubSub client
    publisher = pubsub_v1.PublisherClient()

    # publish your message to the topic
    topic_path = publisher.topic_path(project_id, topic_id)
    future = publisher.publish(topic_path, data, **attributes)

    print(future.result())
    print(f'Published messages with custom attributes to {topic_path}.')

def move_to_invalid_file_folder(bucket_name: str, blob_path: str):
    """
    Move an invalid file from the input/ to the invalid/ subfolder.

    Args:
         bucket_name (str): Bucket name of the file.
         blob_path (str): Path of the blob inside the bucket.
    """

    ## this small part is here to be able to simulate the function but
    ## remove this part when you are ready to deploy your Cloud Function. 
    ## [start simulation]
    print('Your file is considered as invalid. It will be moved to invalid/.')
    return
    ## [end simulation]
    
    
    # connect to the Cloud Storage client
    storage_client = storage.Client()

    # move the file to the invalid/ subfolder
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_path)
    new_blob_path = blob_path.replace('input', 'invalid')
    bucket.rename_blob(blob, new_blob_path)

    print(f'{blob.name} moved to {new_blob_path}')


if __name__ == '__main__':
    
    # here you can test with mock data the function in your local machine
    # it will have no impact on the Cloud Function when deployed.
    import os
    
    project_id = 'sandbox-achmiel' 

    realpath = os.path.realpath(__file__)
    material_path = os.sep.join(['', *realpath.split(os.sep)[:-4], '__materials__'])
    init_files_path = os.path.join(material_path, 'data', 'init')

    # test your Cloud Function with each of the given files.
    for file_name in os.listdir(init_files_path):
        print(f'\nTesting your file {file_name}')
        mock_event = {
            'bucket': f'{project_id}-magasin-cie-landing',
            'name': os.path.join('input', file_name)
        }

        mock_context = {}
        check_file_format(mock_event, mock_context)
#has successfully passed the tests