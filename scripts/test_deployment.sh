#!/bin/bash

# Variables
CLUSTER_NAME="ecs-cluster"
SERVICE_NAME="server-service"

# Step 1: List tasks in the ECS service
TASK_ARNS=$(aws ecs list-tasks --cluster $CLUSTER_NAME --service-name $SERVICE_NAME --query 'taskArns' --output text)

if [ -z "$TASK_ARNS" ]; then
    echo "No tasks found for the service $SERVICE_NAME in the cluster $CLUSTER_NAME."
    exit 1
fi

# Step 2: Describe tasks to get network details
TASK_DETAILS=$(aws ecs describe-tasks --cluster $CLUSTER_NAME --tasks $TASK_ARNS --query 'tasks[*].attachments[0].details[?name==`networkInterfaceId`].value' --output text)

if [ -z "$TASK_DETAILS" ]; then
    echo "No network details found for the tasks."
    exit 1
fi

# Step 3: Get public IP addresses from the network interfaces
for ENI_ID in $TASK_DETAILS; do
    PUBLIC_IP=$(aws ec2 describe-network-interfaces --network-interface-ids $ENI_ID --query 'NetworkInterfaces[0].Association.PublicIp' --output text)
    TASK_ID=$(aws ecs describe-tasks --cluster $CLUSTER_NAME --tasks $TASK_ARNS --query 'tasks[?attachments[0].details[?value==`'"$ENI_ID"'`]].taskArn' --output text)

    echo "ECS Cluster Name: $CLUSTER_NAME"
    echo "Service Name: $SERVICE_NAME"
    echo "Task ID: $TASK_ID"
    echo "Public IP: $PUBLIC_IP"
done

# Test Deployment:

# Test server version endpoint
echo -e "\nTesting server version endpoint:"
curl -sS http://${PUBLIC_IP}:5000/version

# Test user usage time endpoint
echo -e "\nTesting user usage time endpoint for user 'EU-AIR':"
curl -sS http://${PUBLIC_IP}:5000/user/EU-AIR/time
echo
