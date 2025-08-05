# resource "aws_security_group" "all_worker" {
#   name_prefix = "all_worker"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0", var.cidr_block]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     description = "Allow all outbound trafic to anywhere"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }
