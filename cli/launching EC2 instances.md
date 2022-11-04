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

```
export name=automation
aws ec2 create-key-pair --key-name $automation --query 'KeyMaterial' --output text > ${automation}.pem
chmod 400 ${automation}.pem
```

To display the fingerprint:

```
aws ec2 describe-key-pairs --key-name MyKeyPair
```

To delete the key pair:

```
aws ec2 delete-key-pair --key-name MyKeyPair
```

## Creating, Configuring, Deleting Security Groups for Amazon EC2

- Reference: https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-sg.html
- You can create a security group that effectively acts as an EC2 firewall. You first must get the VPC id where you want to create the EC2 instance.

### Describe VPCs

```
aws ec2 describe-vpcs
```

- Then you can create a shell variable with the vpc id and create a security group:

```
vpc_id=<your vpc id>
aws ec2 create-security-group --group-name my-sg --description "My Security Group" --vpc-id $vpc_id
```

- By setting an environment variable to the returned sg id you can then describe the group:

```
sg_id=<your security group id returned in the previous step>
aws ec2 describe-security-groups --group-ids $sg_id
```

### Add Rules to the Security Group

- To determine your public IP address use the following service: https://checkip.amazonaws.com/

```
curl https://checkip.amazonaws.com
aws ec2 authorize-security-group-ingress --group-id sg-903004f8 --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-903004f8 --protocol tcp --port 80 --cidr 0.0.0.0/0
```

- Describe security groups again to see the added rules:

```
sg_id=<your security group id returned in the previous step>
aws ec2 describe-security-groups --group-ids $sg_id
```

### Delete Security Group

```
aws ec2 delete-security-group --group-id $sg_id
```

### Finding an Image

- Reference: https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html

```
aws ec2 describe-images \
  --region us-east-1
```

### Launching an Instance

- Reference: https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html

```
aws ec2 run-instances \
  --image-id ami-xxxxxxxx \
  --count 1 \
  --instance-type t2.micro \
  --key-name MyKeyPair \
  --security-group-ids sg-903004f8 \
  --subnet-id subnet-6e7f829e
```

### Terminate running instances

```
aws ec2 terminate-instances --instance-ids $EC2
```

