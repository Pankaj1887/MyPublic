terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.27"
        }
    }

    required_version = ">= 0.14.9"

}

provider "aws" {
    profile = "default"
    region = "ap-south-1"
}

module "vpc1" {
    source = "git::https://github.com/Pankaj1887/MyPublic.git//tfmodules/vpc"
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    environment = "env1"
    product = "prod1"
    name = "vpc-prod1"

}


module "subnet1" {
    source = "git::https://github.com/Pankaj1887/MyPublic.git//tfmodules/subnet"
    subnet_cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = false
    vpc_id = module.vpc1.id
    environment = "env1"
    product = "prod1"
    name = "subnet-prod1"

}
