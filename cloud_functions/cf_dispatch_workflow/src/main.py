import os
import time
import json
import base64

from google.cloud import storage
from google.cloud import bigquery
from google.cloud.workflows import executions_v1


def receive_messages(event: dict, context: dict):
    """
    Triggered from a message on a Cloud Pub/Sub topic.
    Inserts a file into the correct BigQuery raw table. If succedded then 
    archive the file and trigger the Cloud Workflow pipeline else move the 
    file to the reject/ subfolder.
    
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """

    # rename the variable to be more specific and write it to the logs
    pubsub_event = event
    print(pubsub_event)
    
    # decode the data giving the targeted table name
    table_name = base64.b64decode(pubsub_event['data']).decode('utf-8')

    # get the blob infos from the attributes
    bucket_name = pubsub_event['attributes']['bucket_name']
    blob_path = pubsub_event['attributes']['blob_path']

    load_completed = False
    try:
        # insert the data into the raw table then archive the file
        insert_into_raw(table_name, bucket_name, blob_path)
        move_file(bucket_name, blob_path, 'archive')
        load_completed = True
        
    except Exception as e:
        print(e)
        move_file(bucket_name, blob_path, 'reject')
        
    # trigger the pipeline if the load is completed
    if load_completed:
        trigger_worflow(table_name)


def insert_into_raw(table_name: str, bucket_name: str, blob_path: str):
    """
    Insert a file into the correct BigQuery raw table.
    
    Args:
         table_name (str): BigQuery raw table name.
         bucket_name (str): Bucket name of the file.
         blob_path (str): Path of the blob inside the bucket.
    """

    # connect to the Cloud Storage client
    storage_client = storage.Client()

    # get the util bucket name where the schemas are stored
    # more: https://cloud.google.com/functions/docs/configuring/env-var#python_37_and_go_111
    util_bucket_name = f'{os.environ["GCP_PROJECT"]}_{os.environ["util_bucket_suffix"]}'
    bucket_util = storage_client.bucket(util_bucket_name)
    
    # get the JSON schema of the file
    blob_schema = bucket_util.blob(os.path.join('schemas', 'raw', f'{table_name}.json'))
    schema = json.loads(blob_schema.download_as_string(client=None))

    # get the uri path of the data to load
    blob_uri = f'gs://{bucket_name}/{blob_path}'

    # connect to the BigQuery client
    bigquery_client = bigquery.Client()

    # construct the table id as `project_id.dataset_id.table_id`
    table_id = bigquery_client.dataset('raw').table(table_name)

    # set the format informations
    if blob_uri.endswith('json'): 
        job_config_params = {
            'source_format': bigquery.SourceFormat.NEWLINE_DELIMITED_JSON,
        }
    elif blob_uri.endswith('csv'):
        job_config_params = {
            'source_format': bigquery.SourceFormat.CSV,
            'skip_leading_rows': 1,
        }
    else:
        raise Exception(f'Unknown format for file {blob_uri}')

    # create job configuration to load the file into BigQuery
    job_config = bigquery.LoadJobConfig(
        schema=schema,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
        **job_config_params
    )

    # run the loading job
    load_job = bigquery_client.load_table_from_uri(
        blob_uri,
        table_id,
        location='eu',  # location must match that of the destination dataset.
        job_config=job_config
    )  # API request

    load_job.result()  # waits for the job to complete.

    # print the resulting number of rows inserted
    destination_table = bigquery_client.get_table(table_id)
    print(f'Loaded {destination_table.num_rows} rows.')


def trigger_worflow(table_name: str):
    """
    Triggers and waits for a `<table_name>_wkf` Workflows pipeline's result within the project ID.
    
    Args:
         table_name (str): BigQuery raw table name.
    """

    # connect to the Cloud Worfkflows client
    execution_client = executions_v1.ExecutionsClient()

    # create a Cloud Workflows execution request
    # projects/{project}/locations/{location}/workflows/{workflow}
    parent = execution_client.workflow_path(
        # retrieve the GCP_PROJECT from the reserved environment variables
        # more: https://cloud.google.com/functions/docs/configuring/env-var#python_37_and_go_111
        project=os.environ['GCP_PROJECT'],
        location=os.environ['wkf_location'],
        workflow=f'{table_name}_wkf',
    )


    # Make the request
    response = execution_client.create_execution(request={'parent': parent})
    print(f'Triggering workflow: {response.name}')

    execution_finished = False
    backoff_delay = 1
    print('Poll every second for result...')
    while not execution_finished:
        execution = execution_client.get_execution(request={"name": response.name})
        execution_finished = execution.state != execution.State.ACTIVE
        print('\t- Waiting for results...')
        time.sleep(backoff_delay)
        backoff_delay *= 5

    print(f'Execution finished with state: {execution.state.name}')
    print(execution.result)
    return execution.result


def move_file(bucket_name, blob_path, new_subfolder):
    """
    Move a file a to new subfolder as root.

    Args:
         bucket_name (str): Bucket name of the file.
         blob_path (str): Path of the blob inside the bucket.
         new_subfolder (str): Subfolder where to move the file.
    """

    # connect to the Cloud Storage client
    storage_client = storage.Client()
    
    # get the bucket and the blob
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_path)

    # move the file to its new root subfolder
    *_, file_name = blob_path.split('/')  
    new_blob_path = os.path.join(new_subfolder, file_name)
    bucket.rename_blob(blob, new_blob_path)

    print(f'{blob.name} moved to {new_blob_path}')


if __name__ == '__main__':

    # here you can test with mock data the function in your local machine
    # it will have no impact on the Cloud Function when deployed.
    import os
    
    project_id = '<YOUR-PROJECT-ID>'

    # test your Cloud Function for the store file.
    mock_event = {
        'data': 'store',
        'attributes': {
            'bucket': f'{project_id}-magasin-cie-landing',
            'file_path': os.path.join('input', 'store_20220531.csv'),
        }
    }

    mock_context = {}
    receive_messages(mock_event, mock_context)
