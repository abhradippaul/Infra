resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = var.dynamodb_name
  hash_key     = "userId"
  range_key    = "taskId"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "taskId"
    type = "S"
  }

  tags = {
    Name        = var.dynamodb_name
    Environment = var.env
  }
}
