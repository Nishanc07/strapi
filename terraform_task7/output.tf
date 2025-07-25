output "strapi_url" {
  description = "Public URL to access Strapi"
  value       = "http://${aws_lb.nisha_alb.dns_name}"
}


output "rds_endpoint" {
  value = aws_db_instance.nisha_rds.endpoint
}