resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "172.16.10.0/24"

  tags = {
    Name = "subnet_1"
  }
}