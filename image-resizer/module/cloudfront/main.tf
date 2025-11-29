resource "aws_cloudfront_origin_access_control" "default_oac" {
  name                              = "default-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_origin_access_control" "lambda" {
  name                              = "lambda-oac"
  description                       = "Origin Access Control for Lambda function URL"
  origin_access_control_origin_type = "lambda"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_response_headers_policy" "cors" {
  name = "cors"

  cors_config {
    access_control_allow_credentials = false
    access_control_allow_headers {
      items = ["*"]
    }
    access_control_allow_methods {
      items = ["GET"]
    }
    access_control_allow_origins {
      items = ["*"]
    }
    access_control_max_age_sec = 600
    origin_override            = false
  }

  custom_headers_config {
    items {
      header   = "x-aws-image-optimization"
      value    = "v1.0"
      override = true
    }
    items {
      header   = "vary"
      value    = "accept"
      override = true
    }
  }
}

data "aws_cloudfront_cache_policy" "cache_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_function" "modify_url" {
  name    = "modify_url"
  runtime = "cloudfront-js-2.0"
  comment = "modify_url"
  publish = true
  code    = file("${path.module}/index.js")
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name              = var.s3_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default_oac.id
    origin_id                = "S3"
  }

  origin {
    domain_name              = replace(replace(var.lambda_function_url, "https://", ""), "/", "")
    origin_id                = "Lambda"
    origin_access_control_id = aws_cloudfront_origin_access_control.lambda.id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Some comment"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
    target_origin_id       = "ImageOriginGroup"

    cache_policy_id            = data.aws_cloudfront_cache_policy.cache_optimized.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.cors.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.modify_url.arn
    }
  }

  origin_group {
    origin_id = "ImageOriginGroup"

    failover_criteria {
      status_codes = [403, 404, 500, 502, 503, 504]
    }

    member {
      origin_id = "S3"
    }

    member {
      origin_id = "Lambda"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    "Name" = "s3_cloudfront"
  }
}

