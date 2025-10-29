resource "aws_cloudfront_origin_access_control" "default_oac" {
  name                              = "default-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "cache_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "origin_request_policy" {
  name = "Managed-AllViewer"
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name              = var.s3_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default_oac.id
    origin_id                = "S3Origin"
  }

  origin {
    domain_name = var.ec2_dns_name
    origin_id   = "EC2Origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "allow-all"
    cache_policy_id        = data.aws_cloudfront_cache_policy.cache_optimized.id
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
    target_origin_id       = "S3Origin"
  }


  ordered_cache_behavior {
    path_pattern           = "/website/*"
    cache_policy_id        = data.aws_cloudfront_cache_policy.cache_optimized.id
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
  }

  ordered_cache_behavior {
    path_pattern             = "/api/*"
    cache_policy_id          = data.aws_cloudfront_cache_policy.cache_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.origin_request_policy.id
    target_origin_id         = "EC2Origin"
    viewer_protocol_policy   = "allow-all"
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    compress                 = true
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

  custom_error_response {
    response_page_path    = "/website/error.html"
    error_code            = 404
    response_code         = 404
    error_caching_min_ttl = 300
  }

  tags = {
    "Name" = "s3_ec2_static_website"
  }
}

