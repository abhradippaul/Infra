resource "aws_api_gateway_rest_api" "s3_api_gateway" {
  name        = "S3ApiGateway"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name                             = "cognito_authorizer"
  rest_api_id                      = aws_api_gateway_rest_api.s3_api_gateway.id
  type                             = "COGNITO_USER_POOLS"
  identity_source                  = "method.request.header.Authorization"
  provider_arns                    = [var.authorizer_arn]
  authorizer_result_ttl_in_seconds = 300
}

resource "aws_api_gateway_resource" "tasks" {
  rest_api_id = aws_api_gateway_rest_api.s3_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.s3_api_gateway.root_resource_id
  path_part   = "/tasks"
}

resource "aws_api_gateway_method" "secure_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id   = aws_api_gateway_resource.tasks.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id

}

