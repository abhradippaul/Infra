# s3 config

module "s3" {
  source         = "./module/s3"
  bucket_name    = "abhradippaul-website-cloudfront"
  cloudfront_arn = module.cloudfront.cloudfront_arn
}

# ec2 instance config

module "ec2" {
  source            = "./module/ec2"
  ec2_ami           = "ami-02d26659fd82cf299"
  ec2_instance_type = "t2.micro"
  ec2_volume_size   = 8
}

# cloudfront config

module "cloudfront" {
  source         = "./module/cloudfront"
  ec2_dns_name   = module.ec2.ec2_dns_name
  s3_domain_name = module.s3.s3_domain_name
  price_class    = "PriceClass_100"
}


