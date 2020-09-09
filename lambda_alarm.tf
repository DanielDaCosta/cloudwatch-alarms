# Module
data "aws_s3_bucket_object" "lambda_alarms" {
  bucket = var.s3_bucket
  key    = "lambda-alarms.zip"
}

module "lambda_alarms" {
  source = "ggit@github.com:DanielDaCosta/lambda-module.git"

  lambda_name             = var.lambda_alarms_discord
  s3_bucket               = var.s3_bucket
  s3_key                  = "lambda-alarms.zip"
  s3_object_version       = data.aws_s3_bucket_object.lambda_alarms.version_id
  environment             = var.environment
  name                    = var.name
  description             = "Send Alerts to Discord"
  role                    = data.aws_iam_role.lambda_exec_role.arn
  runtime                 = "python3.7"

  environment_variables = {
    WEBHOOK_URL  = "WEBHOOK_IN_HERE"
  }

  allowed_triggers = {
    AllowExecutionFromSNS = {
      service    = "sns"
      source_arn = data.aws_sns_topic.sns_alarms.arn
    }
  }
}
