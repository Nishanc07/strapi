data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}
data "aws_iam_role" "codedeploy_role" {
  name = "CodeDeployServiceRole"
}
resource "aws_iam_role_policy" "codedeploy_inline_policy" {
  name = "CodeDeployECSPermissions"
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

resource "aws_iam_role_policy_attachment" "codedeploy_ecs_policy" {
  role       = data.aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
