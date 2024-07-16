variable "aws_account_id" {
  description = "The AWS account ID to use for ECR repository URL."
  type        = string
}

variable "aws_region" {
  description = "The AWS region to use for resources."
  type        = string
}

variable "image_version" {
  description = "Image tag"
  type        = string
}

variable "server_repo_name" {
  description = "Name of Server container image repository"
  type        = string 
}

variable "worker_repo_name" {
  description = "Name of Worker container image repository"
  type        = string 
}
