output "strapi_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.nisha_ec2.public_ip
} 