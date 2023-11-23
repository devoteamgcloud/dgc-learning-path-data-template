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

    # TODO: 2
    # You have to try to insert the file into the correct raw table using the python BigQuery Library. 
    # Please, refer yourself to the documentation and StackOverflow is still your friend ;)
    # As an help, you can follow those instructions:
    #     - connect to the Cloud Storage client
    #     - get the util bucket object using the os environments
    #     - loads the schema of the table as a json (dictionary) from the bucket
    #     - store in a string variable the blob uri path of the data to load (gs://your-bucket/your/path/to/data)
    #     - connect to the BigQuery Client
    #     - store in a string variable the table id with the bigquery client. (project_id.dataset_id.table_name)
    #     - create your LoadJobConfig object from the BigQuery librairy
    #     - (maybe you will need more variables according to the type of the file - csv, json - so it can be good to see the documentation)
    #     - and run your loading job from the blob uri to the destination raw table
    #     - waits the job to finish and print the number of rows inserted
    # 
    # note: this is not a small function. Take the day or more if you have to.

    # GCS
    # Connect to the Cloud Storage client
    storage_client = storage.Client()

    # Get the util bucket object using the os environments
    data_bucket = storage_client.bucket(bucket_name)
    data_blob = data_bucket.blob(blob_path)
    
    #Get the file and extension (it will be useful for the LoadJob)
    *subfolders, file_name = blob_path.split(os.sep)
    *file, file_extension = file_name.split(".")

    #Loads the schema of the table as a json (dictionary) from the bucket
    schema_bucket = storage_client.bucket("sandbox-vaneecloo-magasin_cie_utils")
    schema = schema_bucket.blob(f"{table_name}_schema.json") #how to know where it is ?
    schema_json = schema.download_as_text()
   
    #Store in a string variable the blob uri path of the data to load (gs://your-bucket/your/path/to/data)
    file_uri = data_blob.media_link()

    #BigQuery
    #Connect to the BigQuery Client
    bq_client = bigquery.Client()

    #Store in a string variable the table id with the bigquery client. (project_id.dataset_id.table_name)
    table_id = bq_client.get_table(table_name).table_id
    
    if file_extension == "csv":
        job_config_param = {
            'source_format': bigquery.SourceFormat.CSV,
            'skip_leading_row': 1
        }
    elif file_extension == "json":
        job_config_param = {
            'source_format': bigquery.SourceFormat.NEWLINE_DELIMITED_JSON,
        }
    else:
        raise ValueError("Unsupported file format (must be 'csv' or 'json')")

    #Create your LoadJobConfig object from the BigQuery librairy (maybe you will need more variables according to the type of the file - csv, json - so it can be good to see the documentation)
    job_config = bigquery.LoadJobConfig(
    schema = schema_json,
    write_disposition = bigquery.WriteDisposition.WRITE_TRUNCATE,
    **job_config_param
    )
    
    #Run your loading job from the blob uri to the destination raw table
    load_job = bq_client.load_table_from_uri(file_uri, table_id, job_config=job_config, location = 'eu')
    #Waits the job to finish and print the number of rows inserted
    load_job.result()
    print(f"Number of inserted rows: {load_job.output_rows}")

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
    #     - wait for the result (with exponential backoff delay will be better)
    #     - be verbose where you think you have to
    
    execution_client = executions_v1.ExecutionsClient()
    
    parent = execution_client.workflow_path(
        project = os.environ['GCP_PROJECT'],
        location = os.environ['wkf_location'],
        workflow = f"{table_name}_wkf"
    )
    
    request = executions_v1.CreateExecutionRequest(parent = parent)
    response = execution_client.create_execution(request = request)
    execution_finished = False
    
    while not execution_finished:
        execution = execution_client.get_execution(request = {"name": response.name})
        execution_finished = execution.state != execution.State.ACTIVE
        print("Waiting for results...")
        time.sleep(5)
    
    print(f"Execution finished with state: {execution.state.name}")
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

    # TODO: 1
    # Now you are confortable with the first Cloud Function you wrote. 
    # Inspire yourself from this first Cloud Function and:
    #     - connect to the Cloud Storage client
    #     - get the bucket object and the blob object
    #     - split the blob path to isolate the file name 
    #     - create your new blob path with the correct new subfolder given from the arguments
    #     - move you file inside the bucket to its destination
    #     - print the actual move you made

    #Connect to the Cloud Storage client
    storage_client = storage.Client()
    #Get the bucket object and the blob object
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_path)
    #Split the blob path to isolate the file name
    *subfolder, file = blob_path.split(os.sep)
    #Create your new blob path with the correct new subfolder given from the arguments + can the new_subfolder not exist ?
    new_blob_path = os.path.join(new_subfolder, file)
    #Move you file inside the bucket to its destination
    destination_blob = bucket.blob(new_blob_path)
    bucket.copy_blob(blob, bucket, destination_blob.name)
    #Print the actual move you made
    print(f'File moved from {blob_path} moved to {new_blob_path}')

if __name__ == '__main__':

    # here you can test with mock data the function in your local machine
    # it will have no impact on the Cloud Function when deployed.
    import os
    
    project_id = 'sandbox-vvaneecloo'

    # test your Cloud Function for the store file.
    mock_event = {
        'data': 'store'.encode('utf-8'),
        'attributes': {
            'bucket': f'{project_id}-magasin-cie-landing',
            'file_path': os.path.join('input', 'store_20220531.csv'),
        }
    }

    mock_context = {}
    receive_messages(mock_event, mock_context)