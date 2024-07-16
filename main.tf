# Define the AWS provider with the specified region
provider "aws" {
  region = var.aws_region
}


# Data sources to fetch subnets and security groups dynamically
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "group-name"
    values = ["default"]
  }
}


# Module for DynamoDB table
module "dynamodb" {
  source     = "./aws/dynamodb"
  table_name = "usage-table"
}

# Module for IAM resources
module "iam" {
  source             = "./aws/iam"
  user_name          = "devops_user"
  sqs_queue_arn      = module.sqs.queue_arn
  dynamodb_table_arn = module.dynamodb.table_arn
}

# Module for SQS queue
module "sqs" {
  source     = "./aws/sqs"
  queue_name = "usage-queue"
}

# Module for ECS cluster and services
module "ecs" {
  source               = "./aws/ecs"
  execution_role_arn   = module.iam.ecs_task_execution_role_arn
  task_role_arn        = module.iam.ecs_task_role_arn
  user_table_name      = module.dynamodb.table_name
  sqs_queue_url        = module.sqs.queue_url
  subnets              = data.aws_subnets.available.ids  
  security_groups      = [data.aws_security_group.default.id]
  ecr_server_repo_name = var.server_repo_name
  ecr_worker_repo_name = var.worker_repo_name    
  imageversion         = var.image_version
  ecr_repository_url   = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com" 
}
