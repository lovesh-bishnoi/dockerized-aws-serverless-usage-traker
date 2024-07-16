variable "user_name" {
  description = "The name of the IAM user."
  type        = string
}

variable "sqs_queue_arn" {
  description = "The ARN of the SQS queue."
  type        = string
}

variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table."
  type        = string
}
