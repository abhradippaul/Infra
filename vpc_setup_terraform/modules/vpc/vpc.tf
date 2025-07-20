locals {
  vpc_info         = "${var.vpc_cidr}-${var.vpc_name}"
  internet_gateway = "demo-gateway${var.vpc_name}"
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_internet_gateway" "demo-gateway" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = local.internet_gateway
  }
}

resource "aws_route_table" "demo-private-route-table" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_nat_gateway.demo-nat.id
  # }

  tags = {
    Name = "demo-private-route-table"
  }
}


resource "aws_route_table" "demo-public-route-table" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-gateway.id
  }

  tags = {
    Name = "demo-public-route-table"
  }
}

resource "aws_subnet" "demo-subnet-public" {
  vpc_id                  = aws_vpc.demo-vpc.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.az_zones[count.index]
  map_public_ip_on_launch = true


  tags = {
    Name     = "demo-subnet-public-${count.index + 1}"
    Vpc_info = local.vpc_info
  }
}

resource "aws_subnet" "demo-subnet-private" {
  vpc_id                  = aws_vpc.demo-vpc.id
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.az_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name     = "demo-subnet-private-${count.index + 1}"
    Vpc_info = local.vpc_info
  }
}


resource "aws_route_table_association" "public_subnet_assign" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.demo-subnet-public[count.index].id
  route_table_id = aws_route_table.demo-public-route-table.id
}
resource "aws_route_table_association" "private_subnet_assign" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.demo-subnet-private[count.index].id
  route_table_id = aws_route_table.demo-private-route-table.id
}

# # resource "aws_eip" "demo-elastic-ip" {

# #   tags = {
# #     "Name" = "demo-elastic-ip"
# #   }
# # }

# # resource "aws_nat_gateway" "demo-nat" {
# #   allocation_id = aws_eip.demo-elastic-ip.id
# #   subnet_id = aws_subnet.demo-subnet-public.id
# #   tags = {
# #     "Name" = "demo-nat"
# #   }
# # }

resource "aws_network_acl" "demo-network-acl-public" {
  vpc_id = aws_vpc.demo-vpc.id
  #   subnet_ids = [aws_subnet.demo-subnet-public[0].id, aws_subnet.demo-subnet-public[1].id]

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "demo-network-acl-public"
  }
}
resource "aws_network_acl" "demo-network-acl-private" {
  vpc_id = aws_vpc.demo-vpc.id
  #   subnet_ids = [aws_subnet.demo-subnet-private[0].id, aws_subnet.demo-subnet-private[1].id]

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "demo-network-acl-public"
  }
}

resource "aws_network_acl_association" "public_subnet_assign" {
  count          = length(var.public_subnet_cidrs)
  network_acl_id = aws_network_acl.demo-network-acl-public.id
  subnet_id      = aws_subnet.demo-subnet-public[count.index].id
}

resource "aws_network_acl_association" "private_subnet_assign" {
  count          = length(var.private_subnet_cidrs)
  network_acl_id = aws_network_acl.demo-network-acl-private.id
  subnet_id      = aws_subnet.demo-subnet-private[count.index].id
}
