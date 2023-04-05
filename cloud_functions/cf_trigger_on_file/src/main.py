import os
import datetime
import logging
from google.cloud import storage
from google.cloud import pubsub_v1

logger = logging.getLogger("cf_trigger_logs")

# This dictionary gives your the requirements and the specifications of the kind
# of files you can receive.
# the keys are the names of the files
# the values give the required extension for each file

FILES_AND_EXTENSION_SPEC = {
    'store': 'csv',
    'customer': 'csv',
    'basket': 'json'
}


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

    logger.debug("I'm here : check file format")

    # rename the variable to be more specific and write it to the logs
    blob_event = event
    logger.info(f'Processing blob: {blob_event["name"]}.')

    # get the bucket name and the blob path
    bucket_name = blob_event['bucket']
    blob_path = blob_event['name']

    # get the subfolder, the file name and its extension
    *subfolder, file = blob_path.split(os.sep)
    subfolder = os.path.join(*subfolder) if subfolder != [] else ''
    file_name, file_extention = file.split('.')

    # Check if the file is in the subfolder `input/` to avoid infinite loop
    assert subfolder == 'input', 'File must be in `input/ subfolder to be processed`'

    logger.info(f'Bucket name: {bucket_name}')
    logger.info(f'File path: {blob_path}')
    logger.info(f'Subfolder: {subfolder}')
    logger.info(f'Full file name: {file}')
    logger.info(f'File name: {file_name}')
    logger.info(f'File Extension: {file_extention}')

    # check if the file name has the good format
    # required format: <table_name>_<date>.<extension>
    try:
        # required to have two parts.
        assert len(file_name.split("_")) == 2
        logger.debug("Passed test 1 : have two parts")

        table_name = file_name.split("_")[0]
        date = file_name.split("_")[1]

        # the first part is required to be an accepted table name
        assert table_name in list(FILES_AND_EXTENSION_SPEC.keys())
        logger.debug("Passed test 2 : valid table name")

        # the second part is required to be a 'YYYYMMDD'-formatted date
        try:
            datetime.datetime.strptime(date, '%Y%m%d')
        except:
            raise Exception("Unvalid suffix format")

        # required to have the expected extension
        assert file_extention in ["csv", "json"]
        logger.debug("Passed test 3 : recognized extension")

        if file_extention == 'csv':
            assert table_name in ["store", "customer"]

        if file_extention == 'json':
            assert table_name == "basket"

        logger.debug("Passed test 4 : valid extension")

        # if all checks are succesful then publish it to the PubSub topic
        publish_to_pubsub(data=table_name.encode('utf-8'),
                          attributes={
                              'bucket_name': bucket_name,
                              'blob_path': blob_path
                          })

    except Exception as e:
        logger.warning(e)
        # the file is moved to the invalid/ folder if one check is failed
        move_to_invalid_file_folder(bucket_name, blob_path)


def publish_to_pubsub(data: bytes, attributes: dict):
    """
    Publish a message to the pubsub topic to insert the file.

    Args:
         data (bytes): Encoded string as data for the message.
         attributes (dict): Custom attributes for the message.
    """

    logger.info('Your file is considered as valid. It will be published to Pubsub.')

    # retrieve the GCP_PROJECT from the reserved environment variables
    # more: https://cloud.google.com/functions/docs/configuring/env-var#python_37_and_go_111
    project_id = os.environ['GCP_PROJECT']
    topic_id = os.environ['pubsub_topic_id']

    # connect to the PubSub client
    publisher = pubsub_v1.PublisherClient()

    # publish your message to the topic
    topic_path = publisher.topic_path(project_id, topic_id)
    future = publisher.publish(topic_path, data, **attributes)

    logger.info(future.result())
    logger.info(f'Published messages with custom attributes to {topic_path}.')


def move_to_invalid_file_folder(bucket_name: str, blob_path: str):
    """
    Move an invalid file from the input/ to the invalid/ subfolder.

    Args:
         bucket_name (str): Bucket name of the file.
         blob_path (str): Path of the blob inside the bucket.
    """

    logger.info('Your file is considered as invalid. It will be moved to invalid/.')

    # connect to the Cloud Storage client
    storage_client = storage.Client()

    # move the file to the invalid/ subfolder
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_path)
    new_blob_path = blob_path.replace('input', 'invalid')
    bucket.rename_blob(blob, new_blob_path)

    logger.info(f'{blob.name} moved to {new_blob_path}')


if __name__ == '__main__':

    # here you can test with mock data the function in your local machine
    # it will have no impact on the Cloud Function when deployed.

    project_id = 'sandbox-achaabene'

    realpath = os.path.realpath(__file__)
    material_path = os.sep.join(
        ['', *realpath.split(os.sep)[:-4], '__materials__'])
    init_files_path = os.path.join(material_path, 'data', 'init')

    # test your Cloud Function with each of the given files.
    for file_name in os.listdir(init_files_path):
        logger.info(f'\nTesting your file {file_name}')
        mock_event = {
            'bucket': f'{project_id}_magasin_cie_landing',
            'name': os.path.join('input', file_name)
        }

        mock_context = {}
        check_file_format(mock_event, mock_context)
