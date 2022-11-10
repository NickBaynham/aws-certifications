region                   = "us-east-1"
s3_bucket_name           = "upat5bucket1"
public_key_path          = "~/.ssh/id_ed25519.pub"
certificate_arn          = "arn:aws:acm:us-east-1:991097286388:certificate/b22965f5-a991-4787-b333-1f826122ba2e"
route53_hosted_zone_name = "upat5.com"
database_name            = "mysql"
database_user            = "db$user"
database_password        = "$rtg%GFr^^6493"
rds_instance_identifier  = "upat5"
allowed_cidr_blocks = ["99.99.99.99/32"]
amis = {
  "eu-west-1" = "ami-ebd02392"
}
instance_type = "t2.micro"
autoscaling_group_min_size = 3
autoscaling_group_max_size = 5
