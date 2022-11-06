import boto3
import os
import sys

sys.path.insert(0, os.path.abspath('...'))


class EC2:
    @staticmethod
    def list_instances(instance_id):
        print('List Instances')
        ec2 = boto3.resource('ec2')
        instance = ec2.Instance(instance_id)
        print(instance)

        for instance in ec2.instances.all():
            print(
                "Id: {0}\nPlatform: {1}\nType: {2}\nPublic IPv4: {3}\nAMI: {4}\nState: {5}\n".format(
                    instance.id, instance.platform, instance.instance_type, instance.public_ip_address,
                    instance.image.id, instance.state
                )
            )

    @staticmethod
    def create_keypair():
        print('List AWS Key Pairs')
        ec2 = boto3.client('ec2')
        response = ec2.describe_key_pairs()
        print('Describe Key Pairs: ', response['ResponseMetadata']['HTTPStatusCode'])

        print('Create an AWS Key Pair')
        response = ec2.create_key_pair(KeyName='AWS_INSTANCES')
        print('Create Key Pair: ', response['ResponseMetadata']['HTTPStatusCode'])
        print(response)

        print('Delete AWS Key Pair')
        response = ec2.delete_key_pair(KeyName='AWS_INSTANCES')
        print('Delete Key Pair: ', response['ResponseMetadata']['HTTPStatusCode'])
        print(response)

        ec2.close()

    @staticmethod
    def create_vpc():
        print('Create VPC')
        ec2 = boto3.client('ec2')
        vpc = ec2.create_vpc(CidrBlock='172.16.0.0/16')
        print('Create VPC: ', vpc['ResponseMetadata']['HTTPStatusCode'])
        vpc1 = vpc['Vpc']
        print(vpc1)

        print('Delete VPC')
        response = ec2.delete_vpc(VpcId=vpc['VpcId'])
        ec2.close()

    @staticmethod
    def create_subnet():
        print('Create Subnet')

    @staticmethod
    def create_ig():
        print('Create IG')
        # create an internet gateway and attach it to VPC
        ec2 = boto3.client('ec2')
        internet_gateway = ec2.create_internet_gateway()
        vpc.attach_internet_gateway(InternetGatewayId=internetgateway.id)
        ec2.close()
