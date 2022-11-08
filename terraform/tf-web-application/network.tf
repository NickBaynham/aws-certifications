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

resource "aws_subnet" "webserver_subnets" {
  count                   = length(data.aws_availability_zones.azs.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)

  tags = {
    Name = "public-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}

resource "aws_security_group" "default" {
  name        = var.web_security_group_name
  description = "Web Servers security group"
  vpc_id      = aws_vpc.vpc.id

  # Allow outbound internet access.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.web_security_group_name
  }
}