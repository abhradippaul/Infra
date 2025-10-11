locals {
  vpc_name = "${var.vpc_name}-${var.env}"
  public_subnet_info = [
    for i in range(length(var.public_subnet_info)) : {
      name       = "${var.public_subnet_info[i].name}-${local.vpc_name}"
      cidr_block = var.public_subnet_info[i].cidr_block,
      subnet_az  = var.public_subnet_info[i].subnet_az
    }
  ]
}
