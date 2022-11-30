# Creating an EC2 Instance with the Console
In this guide, we will create a new EC2 instance in AWS and connect to it using SSH from the local PC. All resources will be created from scratch - so no default resources will be assumed in the target environment

## Create a VPC
[ VPC ] -> [ Subnet ] -> [ Routes ] -> [ Connections ]

1. Navigate to: aws.amazon.com
2. Sign in with your AWS credentials or sign up for a new account
3. Navigate to the VPC dashboard: https://us-east-1.console.aws.amazon.com/vpc/home?region=us-east-1#Home
4. Click the 'Create VPC' button
5. Select the options
   - VPC and more
   - Auto-generate tags with the project name
   - 1 AZ
   - 1 public subnet, no private
   - No NAT or endpoints

## Create a Key Pair

1. Navigate to: aws.amazon.com
2. Sign in with your AWS credentials or sign up for a new account
3. Navigate to the EC2 dashboard
4. Select Key Pairs
5. Create a new named key pair and download the private pem
6. Use chmod 400 to set permissions

## Create an EC2 Instance

1. Navigate to: aws.amazon.com
2. Sign in with your AWS credentials or sign up for a new account
3. Navigate to the EC2 dashboard
4. Select the EC2 instance wizard
5. Select Launch Instance
6. Enter a name for the instance
7. Select the VPC created earlier
8. Enable public IP assign
9. Select allow SSH, HTTP, and HTTPS
10. Click Launch Instance
11. Verify your EC2 instance in the console

## Connect to the EC2 Instance
```commandline
ssh ec2-user@54.209.20.33 -i ~/.ssh/ec2.pem
```

## Terminate the EC2 Instance

1. Sign in and go to the EC2 page and view instances
2. Select the instance and terminate

## Delete the Key Pair

1. Sign in and go to the EC2 Key Pair page and list Key Pairs
2. Select and delete the Key Pair

## Delete the Network

1. Navigate to VPC
2. List VPC and select/delete the VPC

## Installing NGINX on an Instance
