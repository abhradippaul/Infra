resource "aws_security_group" "alb_webserver_security_group" {
  name        = "alb_webserver_security_group"
  description = "ALB webserver"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lb" "alb_private_ec2" {
  #   name               = "alb_private_ec2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_webserver_security_group.id]
  subnets            = var.public_subnet
  depends_on         = [aws_security_group.alb_webserver_security_group]
}

resource "aws_lb_target_group" "alb_private_ec2_target_group" {
  #   name = "alb_private_ec2_target_group"
  #   target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_listener" "alb_listener_private_ec2" {
  load_balancer_arn = aws_lb.alb_private_ec2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_private_ec2_target_group.arn
  }
  depends_on = [aws_lb.alb_private_ec2]
}
