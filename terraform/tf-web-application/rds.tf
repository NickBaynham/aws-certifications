resource "aws_db_instance" "default" {
  identifier                = var.rds_instance_identifier
  allocated_storage         = 5
  engine                    = "mysql"
  engine_version            = "5.6.35"
  instance_class            = "db.t2.micro"
//  name                      = "${var.database_name}"
  username                  = var.database_user
  password                  = var.database_password
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids    = [aws_security_group.rds_security_group.id]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
}

resource "aws_db_parameter_group" "default" {
  name        = "${var.rds_instance_identifier}-param-group"
  description = "Terraform example parameter group for mysql5.6"
  family      = "mysql5.6"
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_launch_template" "template" {
  user_data = filebase64("${path.module}/scripts/provision.sh")
}