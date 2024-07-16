output "AWS_REGION" {
  value = var.aws_region
}

output "AWS_SQS_QUEUE_URL" {
  value = module.sqs.queue_url
}
