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
