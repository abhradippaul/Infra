resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 1
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "cdn-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_permissions_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = ["${var.raw_bucket_arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${var.transformed_bucket_arn}/*"]
  }
}

resource "aws_iam_role_policy" "lambda_permissions" {
  name   = "lambda-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_permissions_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/sharp"
  output_path = "${path.module}/function.zip"
}

resource "aws_lambda_function" "url_rewrite" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.lambda_name
  role             = aws_iam_role.lambda.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs22.x"
  publish          = true
  timeout          = 30
  logging_config {
    log_format            = "JSON"
    application_log_level = "INFO"
    system_log_level      = "WARN"
  }

  environment {
    variables = {
      originalImageBucketName    = var.S3_ORIGINAL_IMAGE_BUCKET
      transformedImageBucketName = var.S3_TRANSFORMED_IMAGE_BUCKET
      transformedImageCacheTTL   = var.TRANSFORMED_IMAGE_CACHE_TTL
      maxImageSize               = var.MAX_IMAGE_SIZE
    }
  }
  tags = {
    Application = var.lambda_name
  }
}

resource "aws_lambda_permission" "allow_cloudfront_invoke" {
  statement_id  = "AllowExecutionFromCloudFront"
  action        = "lambda:InvokeFunctionUrl"
  function_name = aws_lambda_function.url_rewrite.function_name
  principal     = "edgelambda.amazonaws.com"
  source_arn    = var.cloudfront_arn
}

resource "aws_lambda_function_url" "image_processor" {
  function_name      = aws_lambda_function.url_rewrite.function_name
  authorization_type = "NONE"
}
