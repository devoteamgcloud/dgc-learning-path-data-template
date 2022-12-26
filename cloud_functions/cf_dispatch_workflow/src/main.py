import os
import time
import json
import base64
from pathlib import Path
import csv
import io

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
    #TODO uncomment et corriger
    # table_name = base64.b64decode(pubsub_event['data']).decode('utf-8')
    table_name = pubsub_event['data']

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

def tmp():
    import yaml

    with open("cloud_functions/cf_dispatch_workflow/env.yaml", "r") as stream:
        try:
            env_tmp = yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)
    return env_tmp

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
    # connect to the Cloud Storage client
    #TODO uncomment
    storage_client = storage.Client('sandbox-nbrami')
    # storage_client = storage.Client()
    #     - get the util bucket object using the os environments
    # bucket_util =  f'{storage_client.project}_magasin_cie_utils'
    # loads the schema of the table as a json (dictionary) from the bucket TODO j'aurais dit stocker avant
    env_tmp = tmp()
    os.environ = os.environ | env_tmp
    project_id = os.environ['GCP_PROJECT']
    util_bucket_suffix = os.environ['util_bucket_suffix']
    raw_store = os.environ['raw_store']

    bucket = storage_client.bucket(f"{project_id}_{util_bucket_suffix}")
    source_blob = bucket.blob(raw_store)
    content_bucket = source_blob.download_as_string().decode("utf-8")
    schema = json.loads(content_bucket)

    # store in a string variable the blob uri path of the data to load (gs://your-bucket/your/path/to/data)
    link_bucket = f"gs://{bucket_name}/{blob_path}"

    # connect to the BigQuery Client
    # TODO : uncomment
    # client = bigquery.Client()
    client = bigquery.Client("sandbox-nbrami")
    # store in a string variable the table id with the bigquery client. (project_id.dataset_id.table_name)
    table = client.get_dataset("raw")
    dataset_id = table.dataset_id
    #TODO corriger ça
    destination = f"{storage_client.project}.{dataset_id}.{table_name}"
    extension = Path(blob_path).suffix
    
    if extension.lower() == ".csv":
        job_config = bigquery.LoadJobConfig(
            schema=schema,
            skip_leading_rows=1,
            source_format=bigquery.SourceFormat.CSV,
        )
    
    elif extension.lower() == ".json":
        job_config = bigquery.LoadJobConfig(
            schema=schema,
            source_format=bigquery.SourceFormat.NEWLINE_DELIMITED_JSON, 
        )
    
    else:
        raise NotImplementedError
    job = client.load_table_from_uri(
        source_uris=link_bucket,
        destination=destination,
        job_config=job_config
    )

    job.result()

    print("jsp")
    # create your LoadJobConfig object from the BigQuery librairy
    #     - (maybe you will need more variables according to the type of the file - csv, json - so it can be good to see the documentation)
    #     - and run your loading job from the blob uri to the destination raw table
    # TODO Line number
    #     - waits the job to finish and print the number of rows inserted
    # 
    # note: this is not a small function. Take the day or more if you have to. 

    pass

def trigger_worflow_tmp(table_name: str):
    """
    Triggers a Cloud Workflows pipeline from the table name which has been updated.
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

    # connection to the cloud workflows client
    execution_client = executions_v1.ExecutionsClient()
    env_tmp = tmp()
    os.environ = os.environ | env_tmp

    # create the fully workflow
    # projects/{project}/locations/{location}/workflows/{workflow}
    workflow = 'sample-workflow'
    parent = execution_client.workflow_path(
        project     = os.environ['GCP_PROJECT'],
        location    = os.environ['wkf_location'],
        # workflow    = f'{table_name}_wkf') TODO corriger
        workflow    = workflow)

    print(f'the fully workflow: {parent}')
    
    # Make the request
    response = execution_client.create_execution(request={"parent": parent})
    print(f"Created execution: {response.name}")

    execution_finished = False
    backoff_delay = 1
    print('Poll every second for result...')
    while not execution_finished:
        execution               = execution_client.get_execution(request={"name": response.name})
        execution_finished      = execution.state != execution.State.ACTIVE
        print('- Waiting for results...')
        time.sleep(backoff_delay)
        backoff_delay *= 5
    
    print(f'- Execution finished with state: {execution.state.name}')
    print(execution.result)
    return execution.result

def trigger_worflow(table_name: str):
    """
    Triggers a Cloud Workflows pipeline from the table name which has been updated.
    
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
    # project = "projectid"
    # location = "us-central1"
    # workflow = "workflowname"
    # arguments = {"first": "Hello", "second":"world"}
    from google.cloud import workflows_v1beta
    from google.cloud.workflows import executions_v1beta
    from google.cloud.workflows.executions_v1beta.types import executions
    from google.cloud.workflows.executions_v1beta.services.executions import ExecutionsClient
    from google.cloud.workflows.executions_v1beta.types import CreateExecutionRequest, Execution
    # parent = "projects/{}/locations/{}/workflows/{}".format(project, location, workflow)
    # execution = Execution(argument = json.dumps(arguments))

    # client = ExecutionsClient()
    # response = None
    # # Try running a workflow:
    # try:
    #     response = client.create_execution( parent=parent, execution=execution)
    # except:
    #     return "Error occurred when triggering workflow execution", 500

    env_tmp = tmp()
    os.environ = os.environ | env_tmp

    # Set up API clients.
    execution_client = executions_v1beta.ExecutionsClient()
    workflows_client = workflows_v1beta.WorkflowsClient()

    # Construct the fully qualified location path.
    workflow = 'sample-workflow'
    parent = execution_client.workflow_path(
        project     = os.environ['GCP_PROJECT'],
        location    = os.environ['wkf_location'],
        # workflow    = f'{table_name}_wkf') TODO corriger
        workflow    = workflow)

    # Execute the workflow.
    response = execution_client.create_execution(request={"parent": parent})
    print(f"Created execution: {response.name}")

    # Wait for execution to finish, then print results.
    execution_finished = False
    backoff_delay = 1  # Start wait with delay of 1 second
    print('Poll every second for result...')
    while (not execution_finished):
        execution = execution_client.get_execution(request={"name": response.name})
        execution_finished = execution.state != executions.Execution.State.ACTIVE

        # If we haven't seen the result yet, wait a second.
        if not execution_finished:
            print('- Waiting for results...')
            time.sleep(backoff_delay)
            backoff_delay *= 2  # Double the delay to provide exponential backoff.
        else:
            print(f'Execution finished with state: {execution.state.name}')
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
    return 
    # connect to the Cloud Storage client
    #TODO uncomment
    storage_client = storage.Client('sandbox-nbrami')
    # storage_client = storage.Client()
    # get the bucket object and the blob object
    bucket = storage_client.bucket(bucket_name)
    source_blob = bucket.blob(blob_path)
    # split the blob path to isolate the file name 
    blob_file = Path(blob_path).name
    # create your new blob path with the correct new subfolder given from the arguments
    new_path = str(Path(new_subfolder) / blob_file)
    # move you file inside the bucket to its destination
    new_blob = bucket.copy_blob(
        source_blob, bucket, new_path
    )

    # print the actual move you made
    print(
        "Blob {} in bucket {} copied to blob {} in bucket {}.".format(
            source_blob.name,
            bucket.name,
            new_blob.name,
            bucket.name,
        )
    )
    bucket.delete_blob(source_blob.name)


if __name__ == '__main__':

    # here you can test with mock data the function in your local machine
    # it will have no impact on the Cloud Function when deployed.
    import os
    project_id = 'sandbox-nbrami'

    # test your Cloud Function for the store file.
    mock_event = {
        'data': 'store',
        'attributes': {
            'bucket_name': f'{project_id}_magasin_cie_landing',
            'blob_path': 'input/store_20220531.csv'
        }
    }

    mock_context = {}
    receive_messages(mock_event, mock_context)
