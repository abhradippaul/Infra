module "s3_website" {
  source      = "./module/s3"
  bucket_name = var.s3_website
  env         = var.env
}

module "cognito" {
  source               = "./module/cognito"
  user_pool_name       = "S3-Website"
  user_poo_client_name = "S3-Website-Client"
}

module "dynamodb" {
  source        = "./module/dynamodb"
  dynamodb_name = "S3-Website"
  env           = var.env
}

module "lambda" {
  source              = "./module/lambda"
  lambda_name         = "S3-Website"
  env                 = var.env
  dynamodb_table_name = module.dynamodb.dynamodb_table_name
}

module "api_gateway" {
  source                           = "./module/api-gateway"
  cognito_user_pool_arn            = module.cognito.user_pool_arn
  lambda_invoke_arn_create_task    = module.lambda.lambda_invoke_arn_create_task
  lambda_invoke_arn_get_tasks      = module.lambda.lambda_invoke_arn_get_tasks
  lambda_invoke_arn_update_task    = module.lambda.lambda_invoke_arn_update_task
  lambda_invoke_arn_delete_task    = module.lambda.lambda_invoke_arn_delete_task
  lambda_function_name_create_task = module.lambda.lambda_function_name_create_task
  lambda_function_name_delete_task = module.lambda.lambda_function_name_delete_task
  lambda_function_name_get_tasks   = module.lambda.lambda_function_name_get_tasks
  lambda_function_name_update_task = module.lambda.lambda_function_name_update_task
}
