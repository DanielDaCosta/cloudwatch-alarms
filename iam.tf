###########################
# Lambda Permission
############################

data "template_file" "db_policy" {
  template = file("policies/lambda-permission.json")
}

resource "aws_iam_policy" "lambda_db_policy" {
  name        = "lambda_policy_db"
  description = "IAM policy for lambda"

  policy = data.template_file.db_policy.rendered
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = "${var.name}-lambda-alarms"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_db_policy.arn
}