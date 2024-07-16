import logging
import boto3
import json
import os

logger = logging.getLogger(__name__)
sqs = boto3.client('sqs')
db = boto3.resource('dynamodb')
queue_url =  os.environ["QUEUE_URL"]

def process_messages():
    response = sqs.receive_message(
        QueueUrl = queue_url,
        MessageAttributeNames=['All'],
        MaxNumberOfMessages=1,
        WaitTimeSeconds=20
    )
    if "Messages" in response:
        for msg in response["Messages"]:
            try:
                json_msg = json.loads(msg["Body"])
                logger.info("Received message: %s", msg["MessageId"])

                receipt_handle = msg['ReceiptHandle']

                table = db.Table(os.environ["USER_TABLE"])
                table.update_item(
                    Key={'User': json_msg["user"]},
                    UpdateExpression="ADD Minutes :n",
                    ExpressionAttributeValues={
                        ':n': json_msg["minutes"]
                    }
                )
                # Delete received message from queue
                sqs.delete_message(
                    QueueUrl=queue_url,
                    ReceiptHandle=receipt_handle
                )
            except Exception as e:
                logger.error("Message could not be processed")
                logger.error(e)


if __name__ == "__main__":
    while 1:
        process_messages()
        