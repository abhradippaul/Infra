resource "aws_security_group" "all_worker" {
  name_prefix = "all_worker"
  vpc_id = module.vpc.vpc_id
}