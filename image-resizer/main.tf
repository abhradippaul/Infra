module "raw_bucket" {
  source         = "./module/s3"
  bucket_name    = var.raw_bucket_name
  env            = var.env
  cloudfront_arn = module.cloudfront.cloudfront_arn
}

module "transformed_bucket" {
  source         = "./module/s3"
  bucket_name    = var.transformed_bucket_name
  env            = var.env
  cloudfront_arn = module.cloudfront.cloudfront_arn
}

module "cloudfront" {
  source              = "./module/cloudfront"
  s3_domain_name      = module.transformed_bucket.bucket_domain_name
  price_class         = "PriceClass_100"
  lambda_edge_arn     = module.lambda.lambda_edge_arn
  lambda_function_url = module.lambda.lambda_function_url
}

module "lambda" {
  source                      = "./module/lambda"
  lambda_name                 = "image-process"
  S3_ORIGINAL_IMAGE_BUCKET    = module.raw_bucket.bucket_id
  S3_TRANSFORMED_IMAGE_BUCKET = module.transformed_bucket.bucket_id
  TRANSFORMED_IMAGE_CACHE_TTL = "max-age=31622400"
  MAX_IMAGE_SIZE              = "4700000"
  cloudfront_arn              = module.cloudfront.cloudfront_arn
  transformed_bucket_arn      = module.transformed_bucket.bucket_arn
  raw_bucket_arn              = module.raw_bucket.bucket_arn
}
