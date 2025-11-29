variable "env" {
  type    = string
  default = "dev"
}

variable "raw_bucket_name" {
  type    = string
  default = "abhradippaul-image-resizer-raw-bucket"
}

variable "transformed_bucket_name" {
  type    = string
  default = "abhradippaul-image-resizer-transformed-bucket"
}

