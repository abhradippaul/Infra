output "cloudfront_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

# output "iam_json" {
#   value = data.aws_iam_policy_document.iam_allow_cloudfront_access.json
# }
