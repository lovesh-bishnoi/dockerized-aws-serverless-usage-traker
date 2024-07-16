#!/bin/bash

# Set variables
AWS_REGION=$(aws configure get region)
SERVER_REPO_NAME="server-container-image"
WORKER_REPO_NAME="worker-container-image"

# Delete ECR repositories
echo "Deleting ECR repository $SERVER_REPO_NAME..."
aws ecr delete-repository --repository-name $SERVER_REPO_NAME --region $AWS_REGION --force

echo "Deleting ECR repository $WORKER_REPO_NAME..."
aws ecr delete-repository --repository-name $WORKER_REPO_NAME --region $AWS_REGION --force

# Destroy Terraform-managed infrastructure
echo "Destroying Terraform-managed infrastructure..."
terraform destroy

# Check if terraform destroy was successful
if [ $? -eq 0 ]; then
    echo "Infrastructure destroyed successfully."
else
    echo "Failed to destroy infrastructure."
    exit 1
fi
