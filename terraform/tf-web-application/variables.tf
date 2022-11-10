variable "region" {}
variable "s3_bucket_name" {}
variable "public_key_path" {}
variable "certificate_arn" {}
variable "route53_hosted_zone_name" {}
variable "rds_instance_identifier" {}
variable "database_name" {}
variable "database_user" {}
variable "database_password" {}
variable "allowed_cidr_blocks" {
  type = list(string)
}
variable "amis" {
  type = map(string)
}
variable "instance_type" {}
variable "autoscaling_group_min_size" {}
variable "autoscaling_group_max_size" {}
variable "web_vpc_name" {
  default = "web-vpc"
}

variable "web_vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "web_vpc_internet_gateway_name" {
  default = "web-internet-gateway"
}

variable "cidr_block_all" {
  default = "0.0.0.0/0"
}

variable "web_security_group_name" {
  default = "web-security-group"
}