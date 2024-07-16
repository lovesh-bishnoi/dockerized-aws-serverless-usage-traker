# Output the name of the DynamoDB table created
output "table_name" {
  value = aws_dynamodb_table.usage_table.name
}

output "table_arn" {
  value = aws_dynamodb_table.usage_table.arn
}
