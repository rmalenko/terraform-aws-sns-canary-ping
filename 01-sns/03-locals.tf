locals {
  domain_name     = "app.admit.me"
  account_id      = data.aws_caller_identity.current.account_id
  bucket_name_log = "canary-ping-logs-${replace(local.domain_name, ".", "-")}"

  subscribers = {
    email_01 = {
      protocol               = "email"
      endpoint               = "email_01@email.com"
      endpoint_auto_confirms = true
    }
    email_02 = {
      protocol               = "email"
      endpoint               = "email_02@email.com"
      endpoint_auto_confirms = true
    }
  }

  rendered_file_content = templatefile("${path.module}/canary.js.tpl", {
    take_screenshot   = false
    api_hostname      = "'https://${local.domain_name}/choose-program-type/'",
    region            = data.aws_region.current.name
    response_code_min = 200
    response_code_max = 308
    timeout           = local.canary_timeout
  })

  zip           = "lambda_canary-${sha256(local.rendered_file_content)}.zip"
  schedule_time = 60 // minutes
  # schedule_expression     = "rate(${local.schedule_time} minutes)"
  schedule_expression     = "cron(0 13-2 ? * *)"     // Every hour, between 01:00 PM UTC and 02:59 AM UTC, every day
  cloudwatch_alarm_period = local.schedule_time * 60 // The period in seconds over which the specified statistic is applied. Valid values are 10, 30, or any multiple of 60 (should be calculated from the frequency of the canary).
  canary_timeout          = 30000
  subnet_ids              = "subnet_ids"
  security_group_ids      = "security_group_ids"

  tags = {
    Project     = replace(local.domain_name, ".", "-")
    managedby   = "Terraform"
    environment = "production"
    team        = "team.dev"
    purpose     = "sns_http_code"
  }
}
