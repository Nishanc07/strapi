resource "aws_sns_topic" "sns" {
  name = "strapi-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = var.alert_email  # Make sure this is in variables.tf
}
