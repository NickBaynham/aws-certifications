output "vpc_id" {
  value = aws_vpc.example.id
}

output "security_group" {
  value = aws_security_group.security_group.id
}

output "subnet_id" {
  value = aws_subnet.subnet_1.id
}