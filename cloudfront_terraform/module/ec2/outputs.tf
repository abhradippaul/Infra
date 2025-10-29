output "ec2_dns_name" {
  value = aws_instance.web_server.public_dns
}
