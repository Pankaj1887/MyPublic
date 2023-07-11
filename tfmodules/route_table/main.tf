resource "aws_route_table" "rt_public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.route_Table_cidr_block
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = var.name
    environment = var.environment
    product = var.product
  }
}