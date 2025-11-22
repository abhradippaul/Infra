# module "s3_website" {
#   source      = "./module/s3"
#   bucket_name = var.s3_website
#   env         = var.env
# }

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
  source         = "./module/api-gateway"
  authorizer_arn = module.cognito.authorizer_arn
}
