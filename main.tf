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

resource "aws_instance" "app_server" {
    ami = "ami-0851b76e8b1bce90b"
    instace_type = "t2.micro"

    tags = {
        Name = "Machine1FromTerraform"
    }
}

resouce "aws_eip""app_ipaddress"{
    
}