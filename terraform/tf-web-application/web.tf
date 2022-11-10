resource "aws_key_pair" "deployer" {
  key_name   = "terraform_deployer"
  public_key = file(var.public_key_path)
}

resource "aws_launch_configuration" "launch_config" {
  name_prefix                 = "web-instance"
  image_id                    = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.id
  security_groups             = [aws_security_group.web_security_group.id]
  associate_public_ip_address = true
  user_data                   = aws_launch_template.template.user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  launch_configuration = aws_launch_configuration.launch_config.id
  min_size             = var.autoscaling_group_min_size
  max_size             = var.autoscaling_group_max_size
  target_group_arns    = [aws_alb_target_group.alb_group.arn]
  vpc_zone_identifier  = [aws_subnet.webserver_subnets.*.id]

  tag {
    key                 = "Name"
    value               = "terraform-example-autoscaling-group"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "web_security_group" {
  name        = "web_security_group"
  description = "Web security group"
  vpc_id      = aws_vpc.vpc.id

  # Allow outbound internet access.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  tags = {
    Name = "terraform-example-security-group"
  }
}
