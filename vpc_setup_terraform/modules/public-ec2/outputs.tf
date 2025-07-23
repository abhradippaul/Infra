output "bastion_public_ip" {
  value = aws_instance.bastion-host.public_ip
}

output "bastion_public_dns" {
  value = aws_instance.bastion-host.public_dns
}

output "bastion_security_group" {
  value = aws_security_group.bastion_security_group.id
}
