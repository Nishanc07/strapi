output "strapi_url" {
  description = "Public URL to access Strapi"
  value       = "http://${aws_lb.nisha_alb.dns_name}"
}


output "rds_endpoint" {
  value = aws_db_instance.nisha_rds.endpoint
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.nisha_cluster.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.nisha_service.name
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.nisha_task.arn
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group used for ECS logs"
  value       = aws_cloudwatch_log_group.nisha_strapi.name
}

output "ecs_dashboard_url" {
  description = "CloudWatch Dashboard (if created)"
  value       = "https://${var.region}.console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=nisha-strapi-dashboard"
}
