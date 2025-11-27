module "s3_website" {
  source         = "./module/s3"
  bucket_name    = var.s3_website
  env            = var.env
  cloudfront_arn = module.cloudfront.cloudfront_arn
}

module "cognito" {
  source         = "./module/cognito"
  user_pool_name = "S3-Website-Cognito"
  env            = var.env
}

module "dynamodb" {
  source        = "./module/dynamodb"
  dynamodb_name = "S3-Website-DynamoDB"
  env           = var.env
}

module "lambda" {
  source              = "./module/lambda"
  lambda_name         = "S3-Website-Lambda"
  env                 = var.env
  dynamodb_table_name = module.dynamodb.dynamodb_table_name
  dynamodb_table_arn  = module.dynamodb.dynamodb_table_arn
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

module "cloudfront" {
  source         = "./module/cloudfront"
  s3_domain_name = module.s3_website.s3_domain_name
  price_class    = "PriceClass_100"
  env            = var.env
}
