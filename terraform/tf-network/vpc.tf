# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "172.16.0.0/16"
}