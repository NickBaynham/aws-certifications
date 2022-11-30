data "template_file" "user_data" {
  template = var.IsUbuntu ? file("${path.module}/userdata_ubuntu.tpl") : file("${path.module}/user_data.tpl")
  vars = {
    db_username      = var.database_user
    db_user_password = var.database_password
    db_name          = var.database_name
    db_RDS           = aws_db_instance.wordpress_db.endpoint
  }
}