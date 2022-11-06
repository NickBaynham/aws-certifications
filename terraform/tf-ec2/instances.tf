resource "aws_instance" "web_server" {
  ami           = var.image_id
  instance_type = "t3.micro"
  key_name      = var.key_name
  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }
  tags = {
    Name = "Web_Server"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id = data.aws_subnet.subnet_1.id

  tags = {
    Name = "primary_network_interface"
  }
}