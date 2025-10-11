output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_name" {
  value = aws_vpc.main.tags
}

output "subnet_id" {
  value = aws_subnet.public_subnet[*].id
  # value = [for subnet in aws_subnet.public_subnet : subnet.id]
}
