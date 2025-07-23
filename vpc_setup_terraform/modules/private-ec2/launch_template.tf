resource "aws_key_pair" "private_ec2_key_pair" {
  public_key = file("./id_ed25519.pub")
  tags = {
    "Name" = "private_ec2_key_pair"
  }
}

resource "aws_security_group" "private_ec2_security_group" {
  name        = "private_ec2_security_group"
  description = "Only ssh is enabled from bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # security_groups = [var.bastion_security_group]
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

resource "aws_launch_template" "private_ec2_template" {
  name                   = "private_ec2_template"
  instance_type          = var.private_ec2_type
  key_name               = aws_key_pair.private_ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.private_ec2_security_group.id]
  image_id               = var.private_ec2_ami
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size           = var.private_ec2_storage
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }



  #   tag_specifications {

  #     tags = {
  #       Name = "test"
  #     }
  #   }

  #   user_data = filebase64("${path.module}/example.sh")
}
