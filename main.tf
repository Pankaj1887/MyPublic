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
    vpc_security_group_ids = [aws_security_group.allow_port80.id]
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
    vpc_security_group_ids = [aws_security_group.allow_port80.id]    
}


#resource "aws_instance" "web003" {
#    ami = "ami-0851b76e8b1bce90b"
#    ami = "ami-000051d5c1a3d7008"
#    instance_type = "t2.micro"

#    tags = {
#        Name = "web003"
#	App = "wordpress"
#	Webserver = "Nginx"
#    }
#    subnet_id = aws_subnet.subnet-1c.id
#}

#resource "aws_eip""app_ipaddress"{
    
#}

resource "aws_security_group" "allow_port80" {
  name        = "allow_port80"
  description = "allow_port80 inbound traffic"
  vpc_id      = aws_vpc.ecommerce-vpc.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_internet_gateway" "myvpc_ig" {
  vpc_id      = aws_vpc.ecommerce-vpc.id    
  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.ecommerce-vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myvpc_ig.id
  }

 # route {
 #   ipv6_cidr_block        = "::/0"
 #   egress_only_gateway_id = aws_egress_only_internet_gateway.foo.id
 # }

  tags = {
    Name = "rt_public"
  }
}

resource "aws_route_table_association" "associate-1a" {
  subnet_id      = aws_subnet.subnet-1a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "associate-1c" {
  subnet_id      = aws_subnet.subnet-1c.id
  route_table_id = aws_route_table.rt_public.id
}