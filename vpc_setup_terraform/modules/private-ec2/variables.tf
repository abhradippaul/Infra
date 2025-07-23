variable "bastion_security_group" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_ec2_type" {
  type = string
  default = "t2.micro"
}

variable "private_ec2_storage" {
  type = number
  default = 8
}

variable "private_ec2_ami" {
  default = string
}


