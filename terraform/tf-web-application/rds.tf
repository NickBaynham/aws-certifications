resource "aws_subnet" "rds" {
  count                   = length(data.aws_availability_zones.azs.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${length(data.aws_availability_zones.azs.names) + count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.azs.names, count.index)
  tags = {
    Name = "rds-${element(data.aws_availability_zones.azs.names, count.index)}"
  }
}