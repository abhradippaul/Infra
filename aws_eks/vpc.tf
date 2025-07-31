locals {
  vpc_name = "demo-vpc-${var.cidr_block}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = var.cidr_block

  azs             = var.az_avail
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false
  map_public_ip_on_launch = true
  default_vpc_enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = local.vpc_name
  }
}

output "vpc_id" {
  value = aws
}