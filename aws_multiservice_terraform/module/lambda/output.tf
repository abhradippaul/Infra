output "lambda_arn" {
  value = aws_lambda_function.lambda_function[*].arn
}

# output "lambda_functionName_and_invokeArn" {
#   value = [
#     {
#       function_name : aws_lambda_function.lambda_function[0].function_name,
#       invoke_arn : aws_lambda_function.lambda_function[0].invoke_arn
#     },
#     {
#       function_name : aws_lambda_function.lambda_function[1].function_name,

#       invoke_arn : aws_lambda_function.lambda_function[1].invoke_arn
#     },
#     {
#       function_name : aws_lambda_function.lambda_function[2].function_name,
#       invoke_arn : aws_lambda_function.lambda_function[2].invoke_arn
#     },
#     {
#       function_name : aws_lambda_function.lambda_function[3].function_name,
#       invoke_arn : aws_lambda_function.lambda_function[3].invoke_arn
#     },
#   ]
# }

output "lambda_invoke_arn_create_task" {
  value = aws_lambda_function.lambda_function[0].invoke_arn
}

output "lambda_invoke_arn_get_tasks" {
  value = aws_lambda_function.lambda_function[1].invoke_arn
}

output "lambda_invoke_arn_update_task" {
  value = aws_lambda_function.lambda_function[2].invoke_arn
}

output "lambda_invoke_arn_delete_task" {
  value = aws_lambda_function.lambda_function[3].invoke_arn
}



output "lambda_function_name_create_task" {
  value = aws_lambda_function.lambda_function[0].function_name
}
output "lambda_function_name_get_tasks" {
  value = aws_lambda_function.lambda_function[1].function_name
}
output "lambda_function_name_update_task" {
  value = aws_lambda_function.lambda_function[2].function_name
}
output "lambda_function_name_delete_task" {
  value = aws_lambda_function.lambda_function[3].function_name
}
