resource "aws_sns_topic" "sns_alarms" {
  name = "${local.name_dash}-sns-alarms"

  tags = {
    Product = local.name_dash
  }
}

resource "aws_sns_topic_subscription" "lambda_alarm" {
  topic_arn = aws_sns_topic.sns_alarms.arn
  protocol  = "lambda"
  endpoint  = "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${local.name_dash}-alarms-discord"
}
