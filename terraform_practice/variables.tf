variable "env" {
  default     = "prod"
  description = "This is for environment"
  type        = string
}

variable "vpc_name" {
  default = "demo-vpc"
  type    = string
}

variable "vpc_tag" {
  type = map(string)
  default = {
    "manged_by"  = "terraform"
    "department" = "devops"
  }
}

variable "public_subnet_info" {
  type = list(object({
    name       = string,
    cidr_block = string,
    subnet_az  = string
  }))
  default = [
    {
      name       = "public-subnet-1",
      cidr_block = "10.0.1.0/24",
      subnet_az  = "ap-south-1a"
    },
    {
      name       = "public-subnet-2",
      cidr_block = "10.0.2.0/24",
      subnet_az  = "ap-south-1b"
    },
  ]
}
