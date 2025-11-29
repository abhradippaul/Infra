variable "lambda_name" {
  type = string
}

variable "S3_ORIGINAL_IMAGE_BUCKET" {
  type = string
}

variable "S3_TRANSFORMED_IMAGE_BUCKET" {
  type = string
}

variable "TRANSFORMED_IMAGE_CACHE_TTL" {
  type = string
}

variable "MAX_IMAGE_SIZE" {
  type = string
}

variable "cloudfront_arn" {
  type = string
}

variable "raw_bucket_arn" {
  type = string
}

variable "transformed_bucket_arn" {
  type = string
}
