variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "az_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "subnet_type" {
  type    = bool
  default = false
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24" ]
}
