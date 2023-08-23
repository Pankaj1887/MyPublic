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
    map_public_ip_on_launch = "true"    
    tags = {
	Name = "subnet-1a"
    }
}


resource "aws_subnet" "subnet-1b"{
    vpc_id = aws_vpc.ecommerce-vpc.id
    cidr_block = "10.10.2.0/24"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = "true"    
    tags = {
	Name = "subnet-1b"
    }
}




resource "aws_instance" "web001" {
#    ami = "ami-0851b76e8b1bce90b"
#    ami = "ami-000051d5c1a3d7008"
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    key_name = "pan2linumum"

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
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    key_name = "pan2linumum"

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
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
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

resource "aws_route_table_association" "associate-1b" {
  subnet_id      = aws_subnet.subnet-1b.id
  route_table_id = aws_route_table.rt_public.id
}


# resource "aws_security_group" "aws_default_sg" {
#   ingress {
#     description      = "HTTP from VPC"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]

#   }
# }

resource "aws_lb_target_group" "mywebservergroup" {
  name     = "webservergroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ecommerce-vpc.id
}

resource "aws_lb_target_group_attachment" "attach_web001" {
  target_group_arn = aws_lb_target_group.mywebservergroup.arn
  target_id        = aws_instance.web001.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_web002" {
  target_group_arn = aws_lb_target_group.mywebservergroup.arn
  target_id        = aws_instance.web002.id
  port             = 80
}


resource "aws_security_group" "lb_webservers_sg" {
  name        = "webservers-80"
  description = "allow HTTP inbound traffic"
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

resource "aws_lb" "lb_webservers" {
  name               = "lb-webservers"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_webservers_sg.id]
  subnets            = [aws_subnet.subnet-1a.id, aws_subnet.subnet-1b.id]
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end_80" {
  load_balancer_arn = aws_lb.lb_webservers.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mywebservergroup.arn
  }
}


resource "aws_launch_configuration" "ecommerce-launch-config" {
  name          = "ecommerce-laucch-config"
  image_id      = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "ecommerce-asg" {
  name                      = "ecommerce-asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.ecommerce-launch-config.name
  vpc_zone_identifier       = [aws_subnet.subnet-1a.id, aws_subnet.subnet-1b.id]

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

}

resource "aws_autoscaling_attachment" "ecommerce-asg-attachment" {
  autoscaling_group_name = aws_autoscaling_group.ecommerce-asg.id
  lb_target_group_arn    = aws_lb_target_group.mywebservergroup.arn
}