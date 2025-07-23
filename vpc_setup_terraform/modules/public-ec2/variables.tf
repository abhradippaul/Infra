variable "bastion_ami" {
  type = string
}

variable "bastion_type" {
  type    = string
  default = "t2.micro"
}

variable "bastion_name" {
  type = string
}

variable "bastion_subnet" {
  type = string
}

variable "bastion_vpc" {
  type = string
}

variable "bastion_storage" {
  type    = number
  default = 8
}
