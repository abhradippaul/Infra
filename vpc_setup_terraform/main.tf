module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "demo-vpc"
}

module "bastion_host" {
  source         = "./modules/public-ec2"
  bastion_ami    = "ami-0f918f7e67a3323f0"
  bastion_name   = "bastion_host"
  bastion_type   = "t2.micro"
  bastion_storage = 8
  bastion_vpc    = module.vpc.vpc_id
  bastion_subnet = module.vpc.public_subnet[0]
}

module "private_ec2_template" {
  source = "./modules/private-ec2"
  bastion_security_group = module.bastion_host.bastion_security_group
  # bastion_security_group = "123"
  private_ec2_type       = "t2.micro"
  vpc_id                 = module.vpc.vpc_id
  private_ec2_ami        = "ami-006ee351dc9e64e9d"
  private_ec2_subnets = module.vpc.private_subnet
  # private_ec2_subnets = module.vpc.public_subnet
  alb_security_group = module.alb_webserver.alb_security_group
  alb_target_group_arn = module.alb_webserver.alb_target_group_arn
}

module "alb_webserver" {
  source        = "./modules/alb"
  public_subnet = module.vpc.public_subnet
  vpc_id = module.vpc.vpc_id
}
