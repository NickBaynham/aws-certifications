resource "aws_vpc" "vpc" {
  cidr_block = var.web_vpc_cidr_block

  tags = {
    Name = var.web_vpc_name
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.web_vpc_internet_gateway_name
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = var.cidr_block_all
  gateway_id             = aws_internet_gateway.gateway.id
}