resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.instance_class
  db_subnet_group_name   = aws_db_subnet_group.RDS_subnet_grp.id
  vpc_security_group_ids = [aws_security_group.RDS_allow_rule.id]
  db_name                = var.database_name
  username               = var.database_user
  password               = var.database_password
  skip_final_snapshot    = true

  # make sure rds manual password changes are ignored
  lifecycle {
    ignore_changes = [password]
  }
}