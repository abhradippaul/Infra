resource "aws_vpc" "terra-demo-vpc-1" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "terra-demo-subnet-1" {
  vpc_id     = aws_vpc.terra-demo-vpc-1.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "terra-demo-subnet-1"
  }
}