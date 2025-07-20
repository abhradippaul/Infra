

# resource "aws_instance" "demo-public-server" {
#   ami                    = "ami-0c250665a887e1ffd"
#   instance_type          = "t2.micro"
#   key_name               = aws_key_pair.demo-key.key_name
#   user_data              = filebase64("script.sh")
#   subnet_id              = aws_subnet.demo-subnet-public.id
#   vpc_security_group_ids = [aws_security_group.demo-security-group-ssh.id]
#   associate_public_ip_address = true

#   tags = {
#     "Name" = "demo-public-server"
#   }
# }
