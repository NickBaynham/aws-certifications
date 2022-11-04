# Launching EC2 Instances

- Reference: https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html
- Before running any commands, set your EC2 credentials (see previous topic)
- You may also need to set your IAM permissions to allow Amazon EC2 access.

## Help

```
aws ec2 help
```

## AWS EC2 Key Pairs
- You must provide the key pair to AWS when creating an instance, and then you will use this key pair to authenticate when you connect to the instance.
- You must have the policy IAMUserSSHKeys
```
export name=instances
aws ec2 create-key-pair --key-name $name --query 'KeyMaterial' --output text > ${name}.pem
chmod 400 ${name}.pem
```

To display the fingerprint:

```
aws ec2 describe-key-pairs --key-name $name
```

## Creating, Configuring, Deleting Security Groups for Amazon EC2

- Reference: https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-sg.html
- You can create a security group that effectively acts as an EC2 firewall. You first must get the VPC id where you want to create the EC2 instance.

### Describe VPCs

```
aws ec2 describe-vpcs
export VPC=<vpc id from above>
```

- Then you can create a shell variable with the vpc id and create a security group:

```
aws ec2 create-security-group --group-name sg_demo --description "My Security Group" --vpc-id $VPC
```

- By setting an environment variable to the returned sg id you can then describe the group:

```
export SG==<your security group id returned in the previous step>
aws ec2 describe-security-groups --group-ids $SG
```

### Add Rules to the Security Group

- To determine your public IP address use the following service: https://checkip.amazonaws.com/

```
export IP=$(curl https://checkip.amazonaws.com)
aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 80 --cidr 0.0.0.0/0
```

- Describe security groups again to see the added rules:

```
aws ec2 describe-security-groups --group-ids $SG
```

### Finding an Image

- Reference: https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html

```
aws ec2 describe-images --region us-east-1 --filters "Name=description,Values=Amazon Linux 2 Kernel 5.10 AMI 2.0.20221004.0 x86_64 HVM gp2"  --output table
export IMAGE=<image id from above> 
```

### Launching an Instance

- Reference: https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html

```
aws ec2 run-instances \
  --image-id $IMAGE \
  --count 1 \
  --instance-type t2.micro \
  --key-name $name \
  --security-group-ids $SG \
  --subnet-id $SG
```

### Describe Instances in Region

```
aws ec2 describe-instances --region us-east-1

```

### Connect to a running EC2 Instance

```
export EC2_HOST=<public host name>
ssh -i "${name}.pem" ec2-user@${EC2_HOST}
```

### Run a script on the host

```
#!/bin/bash  
yum update -y
yum install httpd -y
echo "<html><body><h1>Hello Cloud Gurus</h1></body></html>" >/var/www/html/index.html
systemctl start httpd
systemctl enable httpd
```

### Terminate running instances

```
export EC2=<id of EC2 instance above>
aws ec2 terminate-instances --instance-ids $EC2
```

### Delete Security Group

```
aws ec2 delete-security-group --group-id $SG
```

### Delete SSH Keys
To delete the key pair:

```
aws ec2 delete-key-pair --key-name $name
```

