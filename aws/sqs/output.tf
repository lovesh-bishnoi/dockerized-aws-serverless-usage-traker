# Output the URL of the SQS queue created
output "queue_url" {
  value = aws_sqs_queue.usage_queue.id
}

output "queue_arn" {
  value = aws_sqs_queue.usage_queue.arn
}
