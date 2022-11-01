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
