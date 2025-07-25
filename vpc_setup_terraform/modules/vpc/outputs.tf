output "vpc_cidr" {
  value = aws_vpc.demo-vpc.cidr_block
}

output "vpc_id" {
  value = aws_vpc.demo-vpc.id
}

output "public_subnet" {
  value = aws_subnet.demo-subnet-public[*].id
}

output "private_subnet" {
  value = aws_subnet.demo-subnet-private[*].id
}
