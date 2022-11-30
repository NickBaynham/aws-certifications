resource "aws_vpc" "prod-vpc" {
  cidr_block           = var.VPC_cidr
  enable_dns_support   = "true" # internal domain name
  enable_dns_hostnames = "true" # internal host name
  instance_tenancy     = "default"
}
