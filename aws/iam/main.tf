# Define an IAM policy allowing specific actions on the SQS queue and DynamoDB table
resource "aws_iam_policy" "sqs-dynambodb-policy" {
  name   = "sqs-dynambodb-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = [
          "sqs:SendMessage",
          "sqs:CreateQueue",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ]
        Resource  = var.sqs_queue_arn
      },
      {
        Effect    = "Allow"
        Action    = [
          "dynamodb:CreateTable",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem"
        ]
        Resource  = var.dynamodb_table_arn
      }
    ]
  })
}

# Create an IAM role for ECS tasks
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  # Attach the custom policy to the ECS task role
  # This allows ECS tasks to perform specified actions on SQS and DynamoDB
    managed_policy_arns = [ aws_iam_policy.sqs-dynambodb-policy.arn ]
}

# Create an IAM role for ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  # Attach the managed policy for ECS task execution
  # This policy provides necessary permissions for ECS task execution
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}
