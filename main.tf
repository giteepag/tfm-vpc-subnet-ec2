#Terraform Block
terraform {
    required_version = "~> 1.0"
    required_providers {
      aws = {
          source  = "hashicorp/aws"
          version = "~> 3.0"
      }
    }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}

#VPC Module
module "myvpc" {
    source = "./modules/vpc"
    myvpc-cidr-block = var.vpc_cidr_block
    myvpc-name = var.vpc_name
}

#Subnet Module
module "mysubnet" {
    source = "./modules/subnets"
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = module.myvpc.my_vpc_id
}

#EC2-SG Module
module "myapp-server" {
  source = "./modules/ec2_sg"
  vpc_id = module.myvpc.my_vpc_id
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  instance_type = var.instance_type
  subnet_id = module.mysubnet.mysubnet_id
}