resource "aws_key_pair" "aws_key_pair" {
  public_key = file("./id_ed25519.pub")
  tags = {
    Name = "bastion-key"
  }
}

resource "aws_security_group" "bastion_security_group" {
  name        = "bastion_security_group"
  description = "Only ssh is enabled"
  vpc_id      = var.bastion_vpc

  ingress {
    from_port        = 22
    to_port          = 22
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

resource "aws_instance" "bastion-host" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_type
  key_name                    = aws_key_pair.aws_key_pair.key_name
  subnet_id                   = var.bastion_subnet
  vpc_security_group_ids      = [aws_security_group.bastion_security_group.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.bastion_storage
    volume_type = "gp3"
  }

  tags = {
    Name = var.bastion_name
  }
}
