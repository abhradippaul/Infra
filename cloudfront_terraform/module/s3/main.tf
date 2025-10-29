resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags = {
    Name        = "Website Bucket"
    Environment = "Dev"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index_page" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "/website/index.html"
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error_page" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "/website/error.html"
  source       = "error.html"
  content_type = "text/html"
}

data "aws_iam_policy_document" "iam_allow_cloudfront_access" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.iam_allow_cloudfront_access.json
}
