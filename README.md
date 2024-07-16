# DevOps Coding Task

This project automates the deployment and testing of tracking user service usage using AWS services such as IAM, ECR, ECS, SQS, and DynamoDB. The deployment is orchestrated using Terraform and Docker.

## Prerequisites

Before proceeding, ensure you have the following installed and configured:

- Docker
- Terraform
- AWS CLI
- Docker Desktop (depending on your environment)

## Steps to Execute the Project

1. **Set Up AWS Credentials:**
   - Create or use an existing AWS IAM user with access to IAM, ECR, ECS, SQS, and DynamoDB.
   - Generate an access key for this user in the AWS Management Console.

2. **Configure AWS CLI:**
   - Run the following command and enter the Access Key ID, Secret Access Key generated in Step 1 and along with AWS region when prompted:
     ```sh
     aws configure
     ```

3. **Execute the Deployment and Testing:**
   - Navigate to the project directory and run the wrapper script `project.sh`:
     ```sh
     ./project.sh
     ```
   - The script will execute in a loop providing the following options:
     - **ENTER 1:** Push Docker images to ECR and deploy infrastructure using Terraform.
     - **ENTER 2:** Test the deployment.
     - **ENTER 3:** Send a message to the DynamoDB table via SQS and check if the message has been processed by testing the deployment again (Option 2).
     - **ENTER 4:** Remove and destroy the infrastructure along with ECR images.
     - **ENTER q:** To exit the loop.

## Directory Structure

- **aws/**
  - **dynamodb/**
    - `main.tf`
    - `output.tf`
    - `variables.tf`
  - **ecs/**
    - `main.tf`
    - `output.tf`
    - `variables.tf`
  - **iam/**
    - `main.tf`
    - `output.tf`
    - `variables.tf`
  - **sqs/**
    - `main.tf`
    - `output.tf`
    - `variables.tf`
- **scripts/**
  - `deploy_infra.sh`
  - `destroy_infra.sh`
  - `push_to_queue.sh`
  - `test_deployment.sh`
- **server/**
  - `Dockerfile`
  - `requirements.txt`
  - `server.py`
  - `uwsgi.ini`
- **worker/**
  - `Dockerfile`
  - `requirements.txt`
  - `worker.py`
  
Make sure to follow these steps sequentially to set up and test the infrastructure. Refer to individual script files for more detailed operations if needed.
