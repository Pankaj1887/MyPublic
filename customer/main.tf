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
    map_public_ip_on_launch = true
    vpc_id = module.vpc1.id
    environment = "env1"
    product = "prod1"
    name = "subnet-prod1"

}

module "security_group" {
    source = "git::https://github.com/Pankaj1887/MyPublic.git//tfmodules/security_group"
    vpc_id = module.vpc1.id
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    environment = "env1"
    product = "prod1"
    name = "securitygroup-prod1"

}

module "internet_gateway" {
    source = "git::https://github.com/Pankaj1887/MyPublic.git//tfmodules/internet_gateway"
    vpc_id = module.vpc1.id
    environment = "env1"
    product = "prod1"
    Name = "internet_gateway-prod1"

}

module "route_table" {
    source = "git::https://github.com/Pankaj1887/MyPublic.git//tfmodules/route_table"
    vpc_id = module.vpc1.id
    cidr_block = "0.0.0.0/0"
    gateway_id = module.internet_gateway.id
    environment = "env1"
    product = "prod1"
    Name = "rt_public-prod1"

}