
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}


resource "aws_iam_role_policy_attachment" "ecs_execution_policy_attachment" {
  role       = data.aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# CodeDeploy Service Role (created manually or via AWS console)
data "aws_iam_role" "codedeploy_role" {
  name = "CodeDeployServiceRole"
}

# Attach necessary inline policies to the CodeDeploy service role
resource "aws_iam_role_policy" "codedeploy_inline_policy" {
  name = "CodeDeployECSPermissions-Nisha"
  role = data.aws_iam_role.codedeploy_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "ecs:ListTasks",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeTasks",
          "elasticloadbalancing:*",
          "ec2:Describe*",
          "autoscaling:CompleteLifecycleAction",
          "autoscaling:DeleteLifecycleHook",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLifecycleHooks",
          "autoscaling:PutLifecycleHook",
          "autoscaling:RecordLifecycleActionHeartbeat",
          "autoscaling:ResumeProcesses",
          "autoscaling:SuspendProcesses",
          "autoscaling:UpdateAutoScalingGroup",
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach the managed AWS policy for CodeDeploy ECS
resource "aws_iam_role_policy_attachment" "codedeploy_managed_policy" {
  role       = data.aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}



