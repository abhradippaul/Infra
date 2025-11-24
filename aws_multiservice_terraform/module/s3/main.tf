resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags = {
    Name        = var.bucket_name
    Environment = var.env
  }

  force_destroy = true

  lifecycle {
    ignore_changes = [tags]
  }
}

# resource "aws_s3_bucket_cors_configuration" "example" {
#   bucket = aws_s3_bucket.bucket.id

#   cors_rule {
#     allowed_headers = ["*"]
#     allowed_methods = ["PUT", "POST", "GET", "HEAD"]
#     allowed_origins = ["*"]
#     max_age_seconds = 3000
#   }
# }

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "iam_allow_cloudfront_access" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
  depends_on = [aws_s3_bucket.bucket]
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.iam_allow_cloudfront_access.json
}

resource "aws_s3_object" "website" {
  for_each = fileset("code/frontend", "**")

  bucket = aws_s3_bucket.bucket.id
  key    = each.value

  source = "code/frontend/${each.value}"

  content_type = lookup(
    {
      "html" = "text/html",
      "css"  = "text/css",
      "js"   = "text/javascript",
      "png"  = "image/png",
      "jpg"  = "image/jpeg",
      # Add other types as needed
    },
    # Get the last element after splitting the key by '.'
    element(split(".", each.value), length(split(".", each.value)) - 1),
    "application/octet-stream"
  )

  # Use filebase64sha256 for a more robust change detection mechanism
  etag = filebase64sha256("code/frontend/${each.value}")
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}
