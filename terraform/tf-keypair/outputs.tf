output "keypair_fingerprint" {
  value = aws_key_pair.ec2_key_pair.fingerprint
}

output "keypair_id" {
  value = aws_key_pair.ec2_key_pair.id
}