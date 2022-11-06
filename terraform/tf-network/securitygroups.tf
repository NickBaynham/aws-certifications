resource "aws_security_group" "security_group" {
  name        = "ec2_security_group"
  description = "Allow HTTP/S and SSH"
  vpc_id      = aws_vpc.example.id

  ingress {
    description = "Allow HTTP Traffic"
    from_port   = "80"
    to_port     = "80"
    protocol    = "http"
  }

  ingress {
    description = "Allow SSH Connections"
    from_port   = "22"
    to_port     = "22"
    protocol    = "ssh"
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
}