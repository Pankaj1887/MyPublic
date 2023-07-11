resource "aws_security_group" "allow_port80" {
  vpc_id     = var.vpc_id

  ingress {
    description      = var.description
    from_port        = var.from_port
    to_port          = var.to_port
    protocol         = var.protocol
    cidr_blocks      = var.security_group_cidr_block
    ipv6_cidr_blocks = var.security_group_ipv6_cidr_block
  }

  tags = {
    Name = var.name
    environment = var.environment
    product = var.product
  }
}