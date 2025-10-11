resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name       = local.vpc_name
    managed_by = var.vpc_tag.manged_by
    department = var.vpc_tag.department
  }
}

# resource "aws_subnet" "public_subnet" {
#   for_each                = { for subnet in var.public_subnet_info : subnet.name => subnet }
#   vpc_id                  = aws_vpc.main.id // Implicit Dependency
#   cidr_block              = each.value.cidr_block
#   depends_on              = [aws_vpc.main] // Explicit Dependency
#   availability_zone       = each.value.subnet_az
#   map_public_ip_on_launch = true

#   tags = {
#     Name = each.value.name
#   }
# }

resource "aws_subnet" "public_subnet" {
  count                   = length(local.public_subnet_info)
  vpc_id                  = aws_vpc.main.id // Implicit Dependency
  cidr_block              = local.public_subnet_info[count.index].cidr_block
  depends_on              = [aws_vpc.main] // Explicit Dependency
  availability_zone       = local.public_subnet_info[count.index].subnet_az
  map_public_ip_on_launch = true

  tags = {
    Name = local.public_subnet_info[count.index].name
  }
}

resource "aws_ebs_volume" "example-ebs" {
  availability_zone = var.public_subnet_info[0].subnet_az
  size              = var.env == "dev" ? 1 : 2

  tags = {
    Name = "Example EBS Volume"
  }
}
