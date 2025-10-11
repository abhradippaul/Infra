output "bastion_host_public_ip" {
  value = module.bastion_host.bastion_public_ip
}

output "alb_dns" {
  value = module.alb_webserver.alb_public_dns
}
