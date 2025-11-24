output "user_pool_id" {
  value = module.cognito.user_pool_id
}

output "client_pool_id" {
  value = module.cognito.client_pool_id
}

output "api_gateway_endpoint" {
  value = module.api_gateway.api_gateway_url
}

output "s3_endpoint" {
  value = module.s3_website.s3_endpoint
}
