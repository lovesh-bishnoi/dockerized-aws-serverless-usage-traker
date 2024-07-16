# Define the DynamoDB table for tracking usage
resource "aws_dynamodb_table" "usage_table" {
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "User"
  name           = var.table_name
  attribute {
    name = "User"
    type = "S"
  }
}
