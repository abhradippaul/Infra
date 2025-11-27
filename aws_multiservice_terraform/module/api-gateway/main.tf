resource "aws_api_gateway_rest_api" "s3_api_gateway" {
  name        = "S3ApiGateway"
  description = "This is my API for demonstration purposes"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_lambda_permission" "lambda_execution_permission" {
  for_each = {
    get    = var.lambda_function_name_get_tasks
    create = var.lambda_function_name_create_task
    update = var.lambda_function_name_update_task
    delete = var.lambda_function_name_delete_task
  }

  statement_id  = "AllowAPIGWInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.s3_api_gateway.execution_arn}/*/*/*"
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "cognito_authorizer"
  rest_api_id   = aws_api_gateway_rest_api.s3_api_gateway.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_user_pool_arn]
}

# Preflght CORS Request
resource "aws_api_gateway_method" "tasks_options" {
  rest_api_id   = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id   = aws_api_gateway_rest_api.s3_api_gateway.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "tasks_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id = aws_api_gateway_rest_api.s3_api_gateway.root_resource_id
  http_method = aws_api_gateway_method.tasks_options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "opt" {
  rest_api_id = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id = aws_api_gateway_rest_api.s3_api_gateway.root_resource_id
  http_method = aws_api_gateway_method.tasks_options.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "tasks_options_response" {
  rest_api_id = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id = aws_api_gateway_rest_api.s3_api_gateway.root_resource_id
  http_method = aws_api_gateway_method.tasks_options.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# GET all tasks
resource "aws_api_gateway_method" "get_tasks_method" {
  rest_api_id   = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id   = aws_api_gateway_rest_api.s3_api_gateway.root_resource_id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "get_tasks_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id             = aws_api_gateway_method.get_tasks_method.resource_id
  http_method             = aws_api_gateway_method.get_tasks_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn_get_tasks
}

# POST create task
resource "aws_api_gateway_method" "create_task_method" {
  rest_api_id   = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id   = aws_api_gateway_rest_api.s3_api_gateway.root_resource_id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "create_task_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id             = aws_api_gateway_rest_api.s3_api_gateway.root_resource_id
  http_method             = aws_api_gateway_method.create_task_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn_create_task
}

resource "aws_api_gateway_resource" "task_id" {
  rest_api_id = aws_api_gateway_rest_api.s3_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.s3_api_gateway.root_resource_id
  path_part   = "{taskId}"
}

# PUT update task
resource "aws_api_gateway_method" "update_task_method" {
  rest_api_id   = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id   = aws_api_gateway_resource.task_id.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "update_task_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id             = aws_api_gateway_resource.task_id.id
  http_method             = aws_api_gateway_method.update_task_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn_update_task
}

# DELETE delete task
resource "aws_api_gateway_method" "delete_task_method" {
  rest_api_id   = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id   = aws_api_gateway_resource.task_id.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "delete_task_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id             = aws_api_gateway_resource.task_id.id
  http_method             = aws_api_gateway_method.delete_task_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn_delete_task
}

# Preflght CORS Request
resource "aws_api_gateway_method" "task_id_options" {
  rest_api_id   = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id   = aws_api_gateway_resource.task_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "task_id_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id = aws_api_gateway_resource.task_id.id
  http_method = aws_api_gateway_method.task_id_options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "task_id_options_response" {
  rest_api_id = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id = aws_api_gateway_resource.task_id.id
  http_method = aws_api_gateway_method.task_id_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "task_id_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.s3_api_gateway.id
  resource_id = aws_api_gateway_resource.task_id.id
  http_method = aws_api_gateway_method.task_id_options.http_method
  status_code = aws_api_gateway_method_response.task_id_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.s3_api_gateway.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.create_task_method,
      aws_api_gateway_integration.create_task_method_integration,
      aws_api_gateway_resource.task_id,

      aws_api_gateway_method.get_tasks_method,
      aws_api_gateway_integration.get_tasks_method_integration,

      aws_api_gateway_method.update_task_method,
      aws_api_gateway_integration.update_task_method_integration,

      aws_api_gateway_method.delete_task_method,
      aws_api_gateway_integration.delete_task_method_integration,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.create_task_method,
    aws_api_gateway_integration.create_task_method_integration,
    aws_api_gateway_resource.task_id,

    aws_api_gateway_method.get_tasks_method,
    aws_api_gateway_integration.get_tasks_method_integration,

    aws_api_gateway_method.update_task_method,
    aws_api_gateway_integration.update_task_method_integration,

    aws_api_gateway_method.delete_task_method,
    aws_api_gateway_integration.delete_task_method_integration,
  ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.s3_api_gateway.id
  stage_name    = "tasks"
}
