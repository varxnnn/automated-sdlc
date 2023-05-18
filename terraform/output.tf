output "public_dns_address" {
  value = aws_instance.ec2_instance.public_ip
}

# resource "local_file" "public_ip" {
#     content  = venafi_certificate.this.private_key_pem
#     filename = "private_key.pem"
# }