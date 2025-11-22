variable "env" {
  type = string
}

variable "lambda_name" {
  type = string
}

variable "lambda_filename" {
  type    = list(string)
  default = ["create_task", "get_tasks", "update_task", "delete_task"]
}

variable "dynamodb_table_name" {
  type = string
}
