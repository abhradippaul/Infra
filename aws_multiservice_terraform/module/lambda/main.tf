resource "aws_cloudwatch_log_group" "cloudwathc_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 3

  lifecycle {
    ignore_changes = all
  }

  tags = {
    Function = var.lambda_name
  }
}

data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]

  }
}

data "aws_iam_policy_document" "dynamodb_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]

    resources = [var.dynamodb_table_arn]
  }
}

resource "aws_iam_role" "dynamodb_role" {
  name               = "dynamodb-fullaccess"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
}

resource "aws_iam_policy" "dynamodb_policy" {
  name   = "dynamodb_policy"
  policy = data.aws_iam_policy_document.dynamodb_policy_document.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.dynamodb_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.dynamodb_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
  count       = length(var.lambda_filename)
  type        = "zip"
  source_file = "${path.module}/lambda-functions/${var.lambda_filename[count.index]}.py"
  output_path = "${path.module}/zipped-function/${var.lambda_filename[count.index]}.zip"
}

resource "aws_lambda_function" "lambda_function" {
  count            = length(var.lambda_filename)
  filename         = "${path.module}/zipped-function/${var.lambda_filename[count.index]}.zip"
  function_name    = "${var.lambda_name}-${var.lambda_filename[count.index]}"
  role             = aws_iam_role.dynamodb_role.arn
  handler          = "${var.lambda_filename[count.index]}.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip[count.index].output_base64sha256
  publish          = true

  runtime = "python3.13"

  logging_config {
    log_format            = "JSON"
    application_log_level = "INFO"
    system_log_level      = "WARN"
  }

  environment {
    variables = {
      ENVIRONMENT = "production"
      TABLE_NAME  = var.dynamodb_table_name
      LOG_LEVEL   = "info"
    }
  }

  tags = {
    Environment = var.env
    Application = "${var.lambda_name}-${var.lambda_filename[count.index]}"
  }

  depends_on = [aws_cloudwatch_log_group.cloudwathc_log_group, data.archive_file.lambda_zip]
}
