output "cloudfront_url" {
  value = module.cloudfront.cloudfront_domain_name
}

# output "iam_json" {
#   value = data.aws_iam_policy_document.iam_allow_cloudfront_access.json
# }
