output "lambda_edge_arn" {
  value = aws_lambda_function.url_rewrite.qualified_arn
}

output "lambda_version" {
  value = aws_lambda_function.url_rewrite.version
}

output "lambda_function_url" {
  value = aws_lambda_function_url.image_processor.function_url
}
