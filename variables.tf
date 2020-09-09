variable "environment" {
  description = "Env"
  default     = "dev"
}

variable "name" {
  description = "Application Name"
  type        = string
}

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
    }
  }
}

variable "region" {
  default = "us-east-1"
}

variable "s3_bucket" {
  description = "Bucket that contains lambdas"
  type        = string
  default     = "lambdas-zip"
}

variable "lambda_alarms_discord" {
  description = "Name for lambda SMS"
  type        = string
  default     = "alarms-discord"
}