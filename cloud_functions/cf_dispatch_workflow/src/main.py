import os
import time
import json
import base64
from unittest import mock

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


@mock.patch.dict(os.environ, {"project_id": "sandbox-sdiouf"})
@mock.patch.dict(os.environ, {"util_bucket_suffix": "magasin_cie_utils"})
def insert_into_raw(table_name: str, bucket_name: str, blob_path: str):
    """
    Insert a file into the correct BigQuery raw table.

    Args:
         table_name (str): BigQuery raw table name.
         bucket_name (str): Bucket name of the file.
         blob_path (str): Path of the blob inside the bucket.
    """

    # TODO: 2
    # You have to try to insert the file into the correct raw table using the python BigQuery Library.
    # Please, refer yourself to the documentation and StackOverflow is still your friend ;)
    # As an help, you can follow those instructions:
    #     - connect to the Cloud Storage client
    storage_client = storage.Client()

    #     - get the util bucket object using the os environments
    bucket_title = storage_client.bucket(f"{os.environ['project_id']}_{os.environ['util_bucket_suffix']}")
    source_blob = bucket_title.blob(f"schemas/raw/{table_name}.json")

    #     - loads the schema of the table as a json (dictionary) from the bucket
    content_bucket = source_blob.download_as_string().decode("utf-8")
    schema = json.loads(content_bucket)

    #     - store in a string variable the blob uri path of the data to load (gs://your-bucket/your/path/to/data)
    data_uri = f"gs://{bucket_name}/{blob_path}"

    #     - connect to the BigQuery Client
    bigquery_client = bigquery.Client()

    #     - store in a string variable the table id with the bigquery client. (project_id.dataset_id.table_name)
    table = bigquery_client.get_dataset("raw")
    dataset_id = table.dataset_id
    table_id = f"{os.environ.get('project_id')}.{dataset_id}.{table_name}"

    #     - create your LoadJobConfig object from the BigQuery library
    #     - (maybe you will need more variables according to the type of the file - csv, json - so it can be good to see the documentation)
    try:
        file_extension = blob_path.split('.')[-1].lower()
    except Exception as e:
        print(e)
        raise Exception(f"Extension (csv or json) are not find  in  {blob_path}")

    if file_extension == "csv":
        job_config = bigquery.LoadJobConfig(
            schema=schema,
            skip_leading_rows=1,
            source_format=bigquery.SourceFormat.CSV,
        )
    elif file_extension == "json":
        job_config = bigquery.LoadJobConfig(
            schema=schema,
            source_format=bigquery.SourceFormat.NEWLINE_DELIMITED_JSON
        )
    else:
        raise Exception(f"Invalid extension {file_extension}")

    #     - and run your loading job from the blob uri to the destination raw table
    try:
        load_job = bigquery_client.load_table_from_uri(
            source_uris=data_uri,
            destination=table_id,
            job_config=job_config
        )
        #     - waits the job to finish and print the number of rows inserted
        # job result
        load_job.result()
    except Exception as e:
        print(f"Cannot load blob : {e}")

    # print the number of rows inserted
    table = bigquery_client.get_table(table_id)
    print(f'Number of rows inserted : {table.num_rows}')

    # note: this is not a small function. Take the day or more if you have to.

    pass


@mock.patch.dict(os.environ, {"project_id": "sandbox-sdiouf"})
@mock.patch.dict(os.environ, {"wkf_location": "europe-west1"})
def trigger_worflow(table_name: str):
    """
    Triggers and waits for a `<table_name>_wkf` Workflows pipeline's result within the project ID.

    Args:
         table_name (str): BigQuery raw table name.
    """

    # TODO: 3
    # This is your final function to implement.
    # At this time, I hope you are more confortable with the Google Documentations for Python libraries.
    # So your are not guide except this little help:
    #     - trigger a Cloud Workflows execution according to the table updated
    # connection to the cloud workflows client
    execution_client = executions_v1.ExecutionsClient()

    # create the fully workflow
    # projects/{project}/locations/{location}/workflows/{workflow}
    parent = execution_client.workflow_path(
        project=os.environ['project_id'],
        location=os.environ['wkf_location'],
        workflow=f"{table_name}_wkf")
    print(f'the fully workflow: {parent}')

    # Make the request
    response = execution_client.create_execution(request={"parent": parent})
    print(f"Created execution: {response.name}")

    #     - wait for the result (with exponential backoff delay will be better)
    execution_finished = False
    backoff_delay = 1
    print('Poll every second for result...')
    while not execution_finished:
        execution = execution_client.get_execution(request={"name": response.name})
        execution_finished = execution.state != execution.State.ACTIVE
        if not execution_finished:
            print('- Waiting for results...')
            time.sleep(backoff_delay)
            backoff_delay *= 2
        else:
            #     - be verbose where you think you have to
            print(f'- Execution finished with state: {execution.state.name}')
            print(execution.result)
            return execution.result

    raise NotImplementedError()


def move_file(bucket_name, blob_path, new_subfolder):
    """
    Move a file a to new subfolder as root.

    Args:
         bucket_name (str): Bucket name of the file.
         blob_path (str): Path of the blob inside the bucket.
         new_subfolder (str): Subfolder where to move the file.
    """

    # TODO: 1
    # Now you are confortable with the first Cloud Function you wrote.
    # Inspire youreslf from this first Cloud Function and:
    #     - connect to the Cloud Storage client
    storage_client = storage.Client()

    #     - get the bucket object and the blob object
    source_bucket = storage_client.bucket(bucket_name)
    source_blob = source_bucket.blob(blob_path)

    #     - split the blob path to isolate the file name
    #     - create your new blob path with the correct new subfolder given from the arguments
    new_blob_path = blob_path.replace(os.path.dirname(blob_path), new_subfolder)

    #     - move you file inside the bucket to its destination
    #     - print the actual move you made
    destination_blob = source_bucket.copy_blob(source_blob, source_bucket, new_blob_path)
    source_bucket.delete_blob(source_blob.name)
    print(
        "Blob {} in bucket {} copied to blob {} in bucket {}.".format(
            source_blob.name,
            source_bucket.name,
            destination_blob.name,
            source_bucket.name,
        ))
    print(f'{blob_path} is moved to {new_blob_path}')

    pass


if __name__ == '__main__':
    # here you can test with mock data the function in your local machine
    # it will have no impact on the Cloud Function when deployed.
    import os

    project_id = 'sandbox-sdiouf'
    data = base64.b64encode('customer'.encode('utf-8'))

    # test your Cloud Function for the store file.
    mock_event = {
        'data': data,
        'attributes': {
            'bucket_name': f'{project_id}_magasin_cie_landing',
            'blob_path': os.path.join('input', 'customer_20220603.csv'),
        }
    }

    mock_context = {}
    receive_messages(mock_event, mock_context)
