resource "aws_ecs_cluster" "nisha_cluster" {
  name = "nisha-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "nisha_strapi" {
  name              = "/ecs/nisha-strapi"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "nisha_task" {
  family                   = "nisha-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repo_name}:${var.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.nisha_strapi.name,
          awslogs-region        = var.region,
          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [
        { name = "DATABASE_CLIENT", value = "postgres" },
        { name = "DATABASE_HOST", value = aws_db_instance.nisha_rds.address },
        { name = "DATABASE_PORT", value = "5432" },
        { name = "DATABASE_NAME", value = "strapidb" },
        { name = "DATABASE_USERNAME", value = "nisha" },
        { name = "DATABASE_PASSWORD", value = "nisha123" },
        { name = "DATABASE_SSL", value = "false" },

        # Strapi secrets
        { name = "APP_KEYS", value = "090TadpTTRZvuM5Fu75COQ==,c8udgtcvVKlGDIMcmqKu+w==,tsHHrNzqiXFBjHNM/79rbA==,/nRmlzj0U/XxgDh8AYzteA==" },
        { name = "API_TOKEN_SALT", value = "oo7Y59VwBZjdfVsTevVUAQ==" },
        { name = "ADMIN_JWT_SECRET", value = "V0bNAdPbUmZPcTeVeRSZDw==" },
        { name = "TRANSFER_TOKEN_SALT", value = "bvqS1Wdms+TMgaZ+brhE9A==" },
        { name = "ENCRYPTION_KEY", value = "vYbedSqFjzpJgzGquSU8Mw==" }
      ]
    }
  ])
}

resource "aws_ecs_service" "nisha_service" {
  name            = "nisha-service"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.nisha_cluster.id
  task_definition = aws_ecs_task_definition.nisha_task.arn

  desired_count = 1
  force_new_deployment = true

  

  network_configuration {
    subnets          = slice(data.aws_subnets.default.ids, 0, 2)  # Use only first 2 subnets
    security_groups = [aws_security_group.nisha_sg.id]
    assign_public_ip = true
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }


  load_balancer {
    target_group_arn = aws_lb_target_group.nisha_blue.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.http]
}
