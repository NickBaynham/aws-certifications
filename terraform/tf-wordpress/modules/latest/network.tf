resource "aws_vpc" "wordpress-vpc" {
  cidr_block           = var.VPC_cidr
  enable_dns_support   = "true" # internal domain name
  enable_dns_hostnames = "true" # internal host name
  instance_tenancy     = "default"
}

# Create Public Subnet for EC2
resource "aws_subnet" "ec2-subnet-public-1" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.subnet1_cidr
  map_public_ip_on_launch = "true" // public subnet
  availability_zone       = var.AZ1
}

# Private subnet for RDS Availability Zone 2
resource "aws_subnet" "rds-subnet-private-1" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.subnet2_cidr
  map_public_ip_on_launch = "false" // private subnet
  availability_zone       = var.AZ2
}

# Private subnet for RDS Availability Zone 3
resource "aws_subnet" "rds-subnet-private-2" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.subnet3_cidr
  map_public_ip_on_launch = "false" // private subnet
  availability_zone       = var.AZ3
}

resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.wordpress-vpc.id
}

resource "aws_route_table" "wordpress-public-rt" {
  vpc_id = aws_vpc.wordpress-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-igw.id
  }
}

# Associating route table to public subnet
resource "aws_route_table_association" "assoc-rt-public-subnet-1" {
  subnet_id      = aws_subnet.ec2-subnet-public-1.id
  route_table_id = aws_route_table.wordpress-public-rt.id
}

resource "aws_security_group" "ec2_allow_rule" {
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.wordpress-vpc.id
  tags = {
    Name = "allow ssh,http,https"
  }
}

# Security group for RDS
resource "aws_security_group" "RDS_allow_rule" {
  vpc_id = aws_vpc.wordpress-vpc.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_allow_rule.id]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow ec2"
  }
}

resource "aws_db_subnet_group" "RDS_subnet_grp" {
  subnet_ids = [aws_subnet.rds-subnet-private-1.id, aws_subnet.rds-subnet-private-2.id]
}