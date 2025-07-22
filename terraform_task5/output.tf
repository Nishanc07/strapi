output "ec2_public_ip" {
  value = aws_instance.strapi_ec2.public_ip
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}

output "private_key_pem" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}