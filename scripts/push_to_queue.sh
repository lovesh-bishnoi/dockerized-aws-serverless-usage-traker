#!/bin/bash

# Retrieve SQS queue URL from Terraform output and remove surrounding quotes
SQS_QUEUE_URL=$(terraform output AWS_SQS_QUEUE_URL | tr -d '"')

# Send message to SQS queue
aws sqs send-message --queue-url $SQS_QUEUE_URL --message-body '{"user":"EU-AIR","minutes":10}'

# Check the exit status of the aws sqs send-message command
if [ $? -eq 0 ]; then
    # If successful, echo success message
    echo -e "Message sent successfully to SQS queue.\n"
else
    # If unsuccessful, echo error message and exit with non-zero status
    echo -e "\nFailed to send message to SQS queue.\n"
    exit 1
fi
