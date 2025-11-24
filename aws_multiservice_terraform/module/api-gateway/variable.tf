variable "cognito_user_pool_arn" {
  type = string
}

# variable "lambda_invoke_uri" {
#   type = string
# }

variable "lambda_invoke_arn_create_task" {
  type = string
}

variable "lambda_invoke_arn_get_tasks" {
  type = string
}

variable "lambda_invoke_arn_update_task" {
  type = string
}

variable "lambda_invoke_arn_delete_task" {
  type = string
}

variable "lambda_function_name_create_task" {
  type = string
}

variable "lambda_function_name_get_tasks" {
  type = string
}

variable "lambda_function_name_update_task" {
  type = string
}

variable "lambda_function_name_delete_task" {
  type = string
}
