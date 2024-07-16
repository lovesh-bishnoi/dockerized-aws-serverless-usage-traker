# Define the SQS queue for receiving usage messages
resource "aws_sqs_queue" "usage_queue" {
  name = var.queue_name
}
