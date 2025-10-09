terraform {
  backend "s3" {
    bucket         = "abhradippaul-terraform-state"
    key            = "terraform-practice/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.16.0"
    }
  }
}
