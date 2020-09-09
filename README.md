# Cloudwatch Alarms with SNS topic

This repository contains the following set up:

- Cloudwatch alarms resources to be created based on the lambda name.
- SNS topic that will be triggered by the alarm
- Lambda-alarm that will send the message received from SNS to a Discord channel through a WEBHOOK_URL

## Files

- lambda/ : Contains the lambda-alarm zip code that is stored in s3
- sns.tf: creates SNS topic
- iam.tf: Lambda permission
- lambda-alarm: Containes lambda-alarm tf file
- cloudwatch.tf: creates alarms

## Usage

```
terraform apply -var-file="variables.tfvars"
```

### Cloudwatch alarms
In this example, the service that is being monitored is: `aws lambda`, but you can easily use it to monitor others services (SQS, ECS, ...).

If you'd like to add a new lambda to me monitored you just have to add it in the following local variable:
```
locals {
  name_dash = "${var.name}-${var.environment}"
  # Lambda with Alarms
  alarms_dimensions = {
    "${var.name}-${var.environment}-lambda-1" = {
      FunctionName = "${var.name}-${var.environment}-lambda-1"
    },
    "lambda-2" = {
      FunctionName = "lambda-y"
    },
    "lambda-3" = {
      FunctionName = "lambda-z"
    },
    "new-lambda" = {
      FunctionName = "NEW-LAMBDA"
    }
  }
}
```

### SNS topic
You will just have to create a SNS topic and link it with your lambda-alarm.

### Lambda-Alarm
This lambda zip is stored in a s3 bucket. You can find the code for the lambda inside the folder `lambda`
