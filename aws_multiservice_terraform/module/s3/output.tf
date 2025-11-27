output "s3_endpoint" {
  value = aws_s3_bucket.bucket.website_endpoint
}

output "s3_domain_name" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}
