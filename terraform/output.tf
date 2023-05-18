output "public_dns_address" {
  value = aws_instance.ec2_instance.public_ip
}
