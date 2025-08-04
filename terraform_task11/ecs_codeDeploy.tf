resource "aws_codedeploy_app" "nisha_strapi" {
  name             = "nisha-codedeploy"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "nisha_strapi_group" {
  app_name               = aws_codedeploy_app.nisha_strapi.name
  deployment_group_name  = "nisha-deployment-group"
  service_role_arn      = data.aws_iam_role.codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                          = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }

    deployment_ready_option {
      action_on_timeout   = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.nisha_cluster.name
    service_name = aws_ecs_service.nisha_service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.http.arn]
      }

      target_group {
        name = aws_lb_target_group.nisha_blue.name
      }

      target_group {
        name = aws_lb_target_group.nisha_green.name
      }
    }
  }
}
