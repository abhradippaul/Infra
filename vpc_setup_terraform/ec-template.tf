# resource "aws_key_pair" "demo-key" {
#   key_name   = "demo-key"
#   public_key = file("id_ed25519.pub")
# }
# resource "aws_security_group" "demo-security-group-ssh" {
#   name   = "demo-security-group-ssh"
#   vpc_id = aws_vpc.demo-vpc.id

#   ingress {
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }
# resource "aws_security_group" "demo-security-group-webaccess" {
#   name   = "demo-security-group-webaccess"
#   vpc_id = aws_vpc.demo-vpc.id

#   ingress {
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_launch_template" "demo-private-server" {
#   image_id      = "ami-0c250665a887e1ffd"
#   instance_type = "t2.micro"
#   name          = "demo-private-server"
#   key_name      = aws_key_pair.demo-key.key_name
#   user_data     = filebase64("script.sh")
#   #   vpc_security_group_ids = [aws_security_group.demo-security-group.id]   
#   network_interfaces {
#     security_groups = [aws_security_group.demo-security-group-ssh.id, aws_security_group.demo-security-group-webaccess.id]
#   }
# }

# # resource "aws_lb" "demo-elb" {
# #   name               = "demo-elb"
# #   internal           = false
# #   load_balancer_type = "application"
# #   security_groups    = [aws_security_group.demo-security-group-webaccess.id]
# #   subnets            = [aws_subnet.demo-subnet-public1.id, aws_subnet.demo-subnet-public2.id, aws_subnet.demo-subnet-public3.id]
# # }

# # resource "aws_lb_target_group" "demo-target-group" {
# #   name        = "demo-target-group"
# #   target_type = "instance"
# #   port        = 80
# #   protocol    = "HTTP"
# #   vpc_id      = aws_vpc.demo-vpc.id
# # }

# # resource "aws_lb_listener" "my_alb_listener" {
# #   load_balancer_arn = aws_lb.demo-elb.arn
# #   port              = "80"
# #   protocol          = "HTTP"

# #   default_action {
# #     type             = "forward"
# #     target_group_arn = aws_lb_target_group.demo-target-group.arn
# #   }
# # }

# # resource "aws_lb_target_group_attachment" "test" {
# #   target_group_arn = aws_lb_target_group.demo-target-group.arn
# #   target_id        = aws_autoscaling_group.demo-asg.id
# #   port             = 80
# # }

# # resource "aws_autoscaling_group" "demo-asg" {
# #   name                      = "demo-asg"
# #   max_size                  = 1
# #   min_size                  = 1
# #   health_check_grace_period = 300
# #   health_check_type         = "EC2"
# #   desired_capacity          = 1
# #   force_delete              = true
# #   vpc_zone_identifier       = [aws_subnet.demo-subnet-private1.id, aws_subnet.demo-subnet-private2.id]
# #   target_group_arns = [ aws_lb_target_group.demo-target-group.arns ]

# #   launch_template {
# #     id      = aws_launch_template.demo-private-server.id
# #     version = "$Latest"
# #   }

# # }

