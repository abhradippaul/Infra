variable "az_avail" {
  type = list(string)
}

variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "eks_name" {
  type = string
  default = "demo-eks"
}

variable "eks_node" {
  type = string
  default = "t3.medium"
}