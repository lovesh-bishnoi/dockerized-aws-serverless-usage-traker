#!/bin/bash

# Retrieve AWS account ID and region
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=$(aws configure get region)
IMAGE_TAG="latest"
SERVER_REPO_NAME="server-container-image"
WORKER_REPO_NAME="worker-container-image"

# Create a terraform.tfvars file with the account ID and region
cat <<EOF > terraform.tfvars
aws_account_id = "${AWS_ACCOUNT_ID}"
aws_region = "${AWS_REGION}"
image_version = "${IMAGE_TAG}"
server_repo_name = "${SERVER_REPO_NAME}"
worker_repo_name = "${WORKER_REPO_NAME}"
EOF


# Pushing Docker images on newly created ECR repository

# ECR login
echo -e "\nLogging into ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Step 1: Create ECR Repositories if they don't exist
echo -e "\nCreating ECR repository $SERVER_REPO_NAME if it doesn't exist...\n"
aws ecr describe-repositories --repository-names $SERVER_REPO_NAME --region $AWS_REGION 2>/dev/null || aws ecr create-repository --repository-name $SERVER_REPO_NAME --region $AWS_REGION

echo -e "Creating ECR repository $WORKER_REPO_NAME if it doesn't exist...\n"
aws ecr describe-repositories --repository-names $WORKER_REPO_NAME --region $AWS_REGION 2>/dev/null || aws ecr create-repository --repository-name $WORKER_REPO_NAME --region $AWS_REGION

# Step 2: Build and Push Docker Images

# Server Image
echo -e "Building and pushing server image...\n"
cd server
docker build -t $SERVER_REPO_NAME .
docker tag $SERVER_REPO_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$SERVER_REPO_NAME:$IMAGE_TAG
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$SERVER_REPO_NAME:$IMAGE_TAG
SERVER_PUSH_SUCCESS=$?

# Worker Image
echo -e "Building and pushing worker image...\n"
cd ../worker
docker build -t $WORKER_REPO_NAME .
docker tag $WORKER_REPO_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$WORKER_REPO_NAME:$IMAGE_TAG
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$WORKER_REPO_NAME:$IMAGE_TAG
WORKER_PUSH_SUCCESS=$?

# Check if both pushes were successful
if [ $SERVER_PUSH_SUCCESS -eq 0 ] && [ $WORKER_PUSH_SUCCESS -eq 0 ]; then
    echo -e "\nDocker images have been successfully pushed to ECR with tag $IMAGE_TAG.\n"
else
    echo -e "\nError: Docker images could not be pushed to ECR.\n"
    exit 1
fi


# Infrastructure deployment on AWS using Terraform

echo -e "Initializing Terraform..."
cd ..
terraform init

echo -e "\nApplying Terraform configuration..."
terraform apply -auto-approve

echo -e "\nTerraform deployment complete.\n"
