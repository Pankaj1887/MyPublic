resource "aws_nat_gateway" "nat_gateway" {
  # allocation_id = var.allocation_id
  subnet_id     = var.subnet_id

  tags = {
    Name = var.name
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  # depends_on = [aws_internet_gateway.example]
}


# resource "aws_nat_gateway" "example" {
#   connectivity_type = "private"
#   subnet_id         = aws_subnet.example.id
# }