############################
# Cloud Watch Alarms
############################

resource "aws_cloudwatch_metric_alarm" "lambda_alarm" {
  for_each = length(keys(local.alarms_dimensions)) > 0 ? local.alarms_dimensions : {}

  alarm_name                = "${each.key}-alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "Errors"
  namespace                 = "AWS/Lambda"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 0
  datapoints_to_alarm       = 1
  alarm_actions             = [aws_sns_topic.sns_alarms.arn]
  alarm_description         = "Triggerd by errors in lambdas"
  treat_missing_data        = "notBreaching"

  dimensions = each.value

  tags = {
    Product = local.name_dash
  }
}
