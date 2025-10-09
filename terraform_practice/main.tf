locals {
  vpc_name        = "${var.vpc_name}-${var.env}"
  public_subnet_1 = "${var.pulic_subnet_name}-1-${var.env}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = local.vpc_name
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = local.public_subnet_1
  }
}
