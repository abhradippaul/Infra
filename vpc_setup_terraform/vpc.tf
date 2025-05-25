resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "demo-private-subnet-1a" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "demo-private-subnet-1a"
  }
}

resource "aws_subnet" "demo-private-subnet-1b" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.1.2.0/24"

  tags = {
    Name = "demo-private-subnet-1b"
  }
}