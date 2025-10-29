resource "aws_key_pair" "aws_key_pair" {
  public_key = file("./id_ed25519.pub")
  tags = {
    Name = "bastion-key"
  }
}

data "aws_ec2_managed_prefix_list" "cloudfront_origin_facing" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group" "web_server_sg" {
  name_prefix = "web_server_sg_"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront_origin_facing.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  security_groups             = [aws_security_group.web_server_sg.name]
  user_data_base64            = filebase64("./script.sh")
  key_name                    = aws_key_pair.aws_key_pair.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "WebServer"
  }
}
