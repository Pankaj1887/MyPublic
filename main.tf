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

resource "aws_vpc" "ecommerce-vpc"{
    cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "subnet-1a"{
    vpc_id = aws_vpc.ecommerce-vpc.id
    cidr_block = "10.10.1.0/24"
    availability_zone = "ap-south-1a"
    tags = {
	Name = "subnet-1a"
    }
}


resource "aws_subnet" "subnet-1b"{
    vpc_id = aws_vpc.ecommerce-vpc.id
    cidr_block = "10.10.2.0/24"
    availability_zone = "ap-south-1b"
    tags = {
	Name = "subnet-1b"
    }
}


resource "aws_subnet" "subnet-1c"{
    vpc_id = aws_vpc.ecommerce-vpc.id
    cidr_block = "10.10.3.0/24"
    availability_zone = "ap-south-1c"
    tags = {
	Name = "subnet-1c"
    }
}

resource "aws_instance" "web001" {
#    ami = "ami-0851b76e8b1bce90b"
    ami = "ami-000051d5c1a3d7008"
    instance_type = "t2.micro"

    tags = {
        Name = "web001"
	App = "wordpress"
#	Webserver = "Nginx"
    }
    subnet_id = aws_subnet.subnet-1a.id
}


resource "aws_instance" "web002" {
#    ami = "ami-0851b76e8b1bce90b"
    ami = "ami-000051d5c1a3d7008"
    instance_type = "t2.micro"

    tags = {
        Name = "web002"
	App = "wordpress"
#	Webserver = "Nginx"
    }
    subnet_id = aws_subnet.subnet-1b.id
}


resource "aws_instance" "web003" {
#    ami = "ami-0851b76e8b1bce90b"
    ami = "ami-000051d5c1a3d7008"
    instance_type = "t2.micro"

    tags = {
        Name = "web003"
	App = "wordpress"
#	Webserver = "Nginx"
    }
    subnet_id = aws_subnet.subnet-1c.id
}

#resource "aws_eip""app_ipaddress"{
    
#}
