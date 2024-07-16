
variable "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
}

variable "user_table_name" {
  description = "DynamoDB table name"
  type        = string
}

variable "sqs_queue_url" {
  description = "SQS queue URL"
  type        = string
}

variable "subnets" {
  description = "Subnets for ECS tasks"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for ECS tasks"
  type        = list(string)
}

variable "imageversion" {
  description = "Version or Tag of the ECR image"
  type        = string
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "ecr_server_repo_name" {
  description = "Name of Server container image repository"
  type        = string 
}

variable "ecr_worker_repo_name" {
  description = "Name of Worker container image repository"
  type        = string 
}

