resource "aws_instance" "web001" {
#    ami = "ami-0851b76e8b1bce90b"
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name

    tags = {
     name = var.name
     environment = var.environment
     product = var.product
      #	Webserver = "Nginx"
    }
    subnet_id = var.subnet_id
    security_group_id = [var.security_group_id]
}
