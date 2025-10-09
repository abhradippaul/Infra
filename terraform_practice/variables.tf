variable "vpc_name" {
  default = "demo-vpc"
}

variable "pulic_subnet_name" {
  default = "demo-public-subnet"
}

variable "env" {
  default     = "prod"
  description = "This is for environment"
}
