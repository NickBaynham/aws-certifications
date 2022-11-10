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

resource "aws_subnet" "rds_subnet" {
  count                   = length(data.aws_availability_zones.azs.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${length(data.aws_availability_zones.azs.names) + count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)
  tags = {
    Name = "rds-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.rds_instance_identifier}-subnet-group"
  description = "Terraform example RDS subnet group"
  subnet_ids  = [aws_subnet.rds_subnet.*.id]
}

resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "RDS MySQL server Security Group"
  vpc_id      = aws_vpc.vpc.id
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.default.id]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_security_group" "alb_security_group" {
  name        = "alb_security_group"
  description = "Application load balancer security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}