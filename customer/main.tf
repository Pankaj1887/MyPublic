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
    security_group_cidr_block      = ["0.0.0.0/0"]
    security_group_ipv6_cidr_block = ["::/0"]
    environment = "env1"
    product = "prod1"
    name = "securitygroup-prod1"

}

module "internet_gateway" {
    source = "git::https://github.com/Pankaj1887/MyPublic.git//tfmodules/internet_gateway"
    vpc_id = module.vpc1.id
    environment = "env1"
    product = "prod1"
    name = "internet_gateway-prod1"

}

module "route_table" {
    source = "git::https://github.com/Pankaj1887/MyPublic.git//tfmodules/route_table"
    vpc_id = module.vpc1.id
    route_Table_cidr_block = "0.0.0.0/0"
    internet_gateway_id = module.internet_gateway.id
    environment = "env1"
    product = "prod1"
    name = "rt_public-prod1"

}

module "route_table_association" {
    source = "git::https://github.com/Pankaj1887/MyPublic.git//tfmodules/route_table_association2"
    subnet_id      = module.subnet1.id
    route_table_id = module.route_table.id

}

module "linux_vm" {
    source = "git::https://github.com/Pankaj1887/MyPublic.git//tfmodules/linux_vm"
    ami = "ami-000051d5c1a3d7008"
    instance_type = "t2.micro"
    key_name = "pan2linumum"
    subnet_id = module.subnet1.id
    security_group_id = module.security_group.id  
    environment = "env1"
    product = "prod1"
    name = "rt_association_public-prod1"
    availability_zone = "ap-south-1b"    

}

