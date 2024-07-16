#!/bin/bash

while true; do
    echo "Choose an option:"
    echo "ENTER 1. Push Docker Images to ECR and deploy infrastructure on AWS"
    echo "ENTER 2. Test the deployed application"
    echo "ENTER 3. Send messages from SQS to DynamoDB"
    echo "ENTER 4. Destroy the deployed infrastructure"
    echo "ENTER q to quit"

    read option

    case $option in
        1) ./scripts/deploy_infra.sh ;;
        2) ./scripts/test_deployment.sh ;;
        3) ./scripts/push_to_queue.sh ;;
        4) ./scripts/destroy_infra.sh ;;
        q) echo "Exiting script..."; break ;;
        *) echo "Invalid option"; ;;
    esac
done
