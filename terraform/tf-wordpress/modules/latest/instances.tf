resource "aws_instance" "wordpress_ec2" {
  ami                    = var.IsUbuntu ? data.aws_ami.ubuntu.id : data.aws_ami.linux2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ec2-subnet-public-1.id
  vpc_security_group_ids = [aws_security_group.ec2_allow_rule.id]
  user_data              = data.template_file.user_data.rendered
  key_name               = aws_key_pair.key-pair.id
  tags = {
    Name = "Wordpress.web"
  }

  root_block_device {
    volume_size = var.root_volume_size # in GB

  }

  depends_on = [aws_db_instance.wordpress_db]
}

resource "aws_key_pair" "key-pair" {
  key_name   = "key-pair"
  public_key = file(var.PUBLIC_KEY_PATH)
}

resource "aws_eip" "eip" {
  instance = aws_instance.wordpress_ec2.id
}

output "IP" {
  value = aws_eip.eip.public_ip
}
output "RDS-Endpoint" {
  value = aws_db_instance.wordpress_db.endpoint
}

output "INFO" {
  value = "AWS Resources and Wordpress has been provisioned. Go to http://${aws_eip.eip.public_ip}"
}

resource "null_resource" "Wordpress_Installation_Waiting" {
   # trigger will create new null-resource if ec2 id or rds is chnaged
   triggers={
    ec2_id=aws_instance.wordpress_ec2.id,
    rds_endpoint=aws_db_instance.wordpress_db.endpoint

  }
  connection {
    type        = "ssh"
    user        = var.IsUbuntu ? "ubuntu" : "ec2-user"
    private_key = file(var.PRIVATE_KEY_PATH)
    host        = aws_eip.eip.public_ip
  }

  provisioner "remote-exec" {
    inline = ["sudo tail -f -n0 /var/log/cloud-init-output.log| grep -q 'WordPress Installed'"]
  }
}