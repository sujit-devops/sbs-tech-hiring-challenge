/*
terraform {
  backend "s3" {
    bucket         = "jshsflaksjflwffjfsuji-terraform-state"
    key            = "Users/sujit/sbs-tech-hiring-challenge-sample/terraform/terraform.tfstate"
    encrypt        = true
    region         = "us-east-1"
    dynamodb_table = "dynamodb-state-locking"
  }
}
*/
provider "aws" {
  region = "us-east-1"
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
  bucket_name = "jshsflaksjflwffjfsuji-terraform-state"
}

module "dynamodb_table" {
  source = "./modules/dynamodb_table"
  table_name = "dynamodb-state-locking"
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
}

module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.vpc_id
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.subnets.subnet_a_id
  security_group_id = module.security_group.security_group_id
  iam_instance_profile_name = module.iam.iam_instance_profile_name
}

module "autoscaling_group" {
  source = "./modules/autoscaling_group"
  launch_configuration_name = module.ec2_instance.launch_configuration_name
  vpc_zone_identifiers      = [module.subnets.subnet_a_id]
}

module "load_balancer" {
  source = "./modules/load_balancer"
  security_group_id = module.security_group.security_group_id
  subnet_ids        = [module.subnets.subnet_a_id]
  target_group_arn  = module.autoscaling_group.target_group_arn
}

module "static_website" {
  source = "./modules/static_website"
}