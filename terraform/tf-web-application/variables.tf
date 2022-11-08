variable "public_key_path" {
  default = "~/.ssh/id_ed25519.pub"
}

variable "certificate_arn" {}

variable "route53_hosted_zone_name" {}

variable "web_vpc_name" {
  default = "upat5-web-vpc"
}

variable "web_vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "web_vpc_internet_gateway_name" {
  default = "upat5-internet-gateway"
}

variable "cidr_block_all" {
  default = "0.0.0.0/0"
}