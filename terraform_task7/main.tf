terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.region
}

# --- Data sources ---
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# --- IAM Role for ECS ---
resource "aws_iam_role" "ecs_task_execution_role_new" {
  name = "ecsTaskExecutionRoleNew"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role_new.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# --- Security Group ---
resource "aws_security_group" "nisha_ecs_sg_new" {
  name        = "nisha-sg-new"
  description = "Allow HTTP and DB access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Log Group ---
resource "aws_cloudwatch_log_group" "nisha_strapi_new" {
  name              = "/ecs/nisha-strapi-new"
  retention_in_days = 7
}

# --- ECS Task Definition ---
resource "aws_ecs_task_definition" "nisha_task" {
  family                   = "nisha-strapi"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role_new.arn
  container_definitions    = jsonencode([
    {
      name      = "strapi"
      image     = "607700977843.dkr.ecr.us-east-2.amazonaws.com/nisha-ecr:${var.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.nisha_strapi_new.name,
          awslogs-region        = var.region,
          awslogs-stream-prefix = "strapi"
        }
      }
    }
  ])
}

# --- Application Load Balancer ---
resource "aws_lb" "nisha_alb" {
  name               = "nisha-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.nisha_ecs_sg_new.id]
}

resource "aws_lb_target_group" "nisha_alb_tg_new" {
  name     = "nisha-alb-tg-new"
  port     = 1337
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  target_type = "ip"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "nisha_alb_listener" {
  load_balancer_arn = aws_lb.nisha_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nisha_alb_tg_new.arn
  }
}

# --- ECS Cluster ---
resource "aws_ecs_cluster" "nisha_cluster" {
  name = "nisha-cluster"
}

# --- ECS Service ---
resource "aws_ecs_service" "nisha_service" {
  name            = "nisha-service"
  cluster         = aws_ecs_cluster.nisha_cluster.id
  task_definition = aws_ecs_task_definition.nisha_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.nisha_ecs_sg_new.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nisha_alb_tg_new.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.nisha_alb_listener]
}
