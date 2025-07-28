resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggered when ECS CPU > 80%"
  dimensions = {
    ClusterName = aws_ecs_cluster.nisha_cluster.name
    ServiceName = aws_ecs_service.nisha_service.name
  }
  
}

resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "HighMemoryUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Triggered when ECS Memory > 75%"
  dimensions = {
    ClusterName = aws_ecs_cluster.nisha_cluster.name
    ServiceName = aws_ecs_service.nisha_service.name
  }
  
}

resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "nisha-strapi-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x = 0
        y = 0
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.nisha_cluster.name, "ServiceName", aws_ecs_service.nisha_service.name],
            ["...", "MemoryUtilization", ".", ".", ".", "."]
          ]
          view = "timeSeries"
          stacked = false
          region = "us-east-2"
          title = "ECS Fargate CPU & Memory"
        }
      }
    ]
  })
}


resource "aws_cloudwatch_metric_alarm" "nlb_healthy_hosts" {
  alarm_name          = "NLB-HealthyHostCount-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Number of healthy nodes in the Target Group dropped below threshold"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.sns.arn]
  ok_actions          = [aws_sns_topic.sns.arn]
  dimensions = {
    TargetGroup  = aws_lb_target_group.nisha_tg.arn_suffix
    LoadBalancer = aws_lb.nisha_alb.arn_suffix
  }

  tags = {
    Name = "NLB HealthyHostCount Alarm"
  }
}
