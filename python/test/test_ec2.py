import os
import sys
import unittest
from python.lib.ec2_provider import EC2
sys.path.insert(0, os.path.abspath('...'))


class TestEC2(unittest.TestCase):

    def test_list_ec2(self):
        """verify listing EC2 instances"""
        instance_id = "i-0083a3611bac5a24c"
        EC2.list_instances(instance_id)

    def test_create_instance(self):
        """create a web server and test"""

        # Create an AWS Key Pair
        EC2.create_keypair()

    def test_create_vps(self):
        """create a vpc and test"""

        EC2.create_vpc()
