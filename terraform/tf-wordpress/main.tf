module "aws_wordpress" {
  source        = "./modules/latest"
  database_name = "wordpress_db"   // database name
  database_user = "wordpress_user" //database username

  // Password here will be used to create master db user.It should be changed later
  database_password       = "PassWord4-user"     //password for user database
  shared_credentials_file = "~/.aws/credentials" //Access key and Secret key file location
  region                  = "us-east-1"          //Virginia US region
  IsUbuntu                = false                // true for ubuntu,false for linux 2  //boolean type

  // availability zone and their CIDR
  AZ1              = "us-east-1a"  // for EC2
  AZ2              = "us-east-1b"  //for RDS
  AZ3              = "us-east-1c"  //for RDS
  VPC_cidr         = "10.0.0.0/16" // VPC CIDR
  subnet1_cidr     = "10.0.1.0/24" // Public Subnet for EC2
  subnet2_cidr     = "10.0.2.0/24" //Private Subnet for RDS
  subnet3_cidr     = "10.0.3.0/24" //Private subnet for RDS
  instance_type    = "t2.micro"    //type of instance
  instance_class   = "db.t2.micro" //type of RDS Instance
  root_volume_size = 22
}