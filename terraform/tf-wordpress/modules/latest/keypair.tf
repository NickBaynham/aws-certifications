resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_name
  public_key = file(var.key_pair_path)
}