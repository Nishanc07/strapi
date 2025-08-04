resource "aws_lb" "nisha_alb" {
  name               = "nisha"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    "subnet-0c0bb5df2571165a9", # us-east-2a
    "subnet-0cc2ddb32492bcc41", # us-east-2b
    "subnet-0f768008c6324831f"  # us-east-2c
  ]
  security_groups = [aws_security_group.nisha_sg.id]
  enable_deletion_protection = false
}


resource "aws_lb_target_group" "nisha_blue" {
  name        = "nisha-blue"
  port        = 1337
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
  health_check {
    path                = "/"
    port                = "1337"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "nisha_green" {
  name        = "nisha-green"
  port        = 1337
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
  health_check {
    path                = "/"
    port                = "1337"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}




resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nisha_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nisha_blue.arn
  }
}
