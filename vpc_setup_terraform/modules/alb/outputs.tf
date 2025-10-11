output "alb_security_group" {
  value = aws_security_group.alb_webserver_security_group.id
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.alb_private_ec2_target_group.arn
}

output "alb_public_dns" {
  value = aws_lb.alb_private_ec2.dns_name
}
