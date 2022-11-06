data "aws_key_pair" "key_pair" {
  key_name = var.key_name
}

data "aws_vpc" "vpc" {
  cidr_block = "172.16.0.0/16"
}

data "aws_subnet" "subnet_1" {
  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = ""
}

data "aws_security_group" "security_group" {
  name = "ec2_security_group"
}