data "archive_file" "lambda_canary_zip" {
  type        = "zip"
  output_path = local.zip
  source {
    content  = local.rendered_file_content
    filename = "nodejs/node_modules/canary.js"
  }
}

resource "aws_synthetics_canary" "canary_api_calls" {
  provider             = aws.aws_main
  name                 = "${replace(local.domain_name, ".", "-")}-http-code"
  artifact_s3_location = "s3://${local.bucket_name_log}"
  execution_role_arn   = aws_iam_role.canary_role.arn
  runtime_version      = "syn-nodejs-puppeteer-9.1"
  handler              = "canary.handler"
  zip_file             = local.zip
  start_canary         = true

  success_retention_period = 1
  failure_retention_period = 3

  schedule {
    expression          = local.schedule_expression
    duration_in_seconds = 0
  }

  run_config {
    timeout_in_seconds = 90
    active_tracing     = false
  }

  #   vpc_config {
  #     subnet_ids         = var.subnet_ids
  #     security_group_ids = [var.security_group_id]
  #   }

  tags = merge(local.tags, {
    application = "aws_synthetics_canary"
  })

  depends_on = [
    data.archive_file.lambda_canary_zip,
  ]

}

resource "aws_iam_role" "canary_role" {
  provider           = aws.aws_main
  name               = "CloudWatchSyntheticsRole"
  assume_role_policy = data.aws_iam_policy_document.canary_assume_role.json
}

data "aws_iam_policy_document" "canary_assume_role" {
  provider = aws.aws_main
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "canary_role_policy" {
  provider   = aws.aws_main
  role       = aws_iam_role.canary_role.name
  policy_arn = aws_iam_policy.canary_policy.arn
}

resource "aws_iam_policy" "canary_policy" {
  provider    = aws.aws_main
  name        = "canary-policy"
  description = "Policy for canary"
  policy      = data.aws_iam_policy_document.canary_permissions.json
}

data "aws_iam_policy_document" "canary_permissions" {
  provider = aws.aws_main
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListAllMyBuckets"
    ]
    resources = [
      module.s3_log_bucket.s3_bucket_arn,
      "${module.s3_log_bucket.s3_bucket_arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation"
    ]
    resources = [
      module.s3_log_bucket.s3_bucket_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "xray:PutTraceSegments"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid    = "CanaryCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
    ]
  }
  statement {
    sid    = "CanaryCloudWatchAlarm"
    effect = "Allow"
    resources = [
      "*"
    ]
    actions = [
      "cloudwatch:PutMetricData"
    ]
    condition {
      test     = "StringEquals"
      values   = ["CloudWatchSynthetics"]
      variable = "cloudwatch:namespace"
    }
  }
  statement {
    sid    = "CanaryinVPC"
    effect = "Allow"
    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:AttachNetworkInterface"
    ]
    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:network-interface/*"
    ]
  }
}


resource "aws_cloudwatch_metric_alarm" "canary_alarm" {
  provider                  = aws.aws_main
  alarm_name                = "canary-alarm-${replace(local.domain_name, ".", "-")}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  period                    = local.cloudwatch_alarm_period
  evaluation_periods        = "1" // The number of periods over which data is compared to the specified threshold.
  metric_name               = "Failed"
  namespace                 = "CloudWatchSynthetics"
  statistic                 = "Sum"
  datapoints_to_alarm       = "1"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = [aws_sns_topic.email_http_ping.arn]
  alarm_actions             = [aws_sns_topic.email_http_ping.arn]
  ok_actions                = [aws_sns_topic.email_http_ping.arn]
  alarm_description         = "Canary alarm for - ${local.domain_name} HTTP responce code is not 200"
  dimensions = {
    CanaryName = aws_synthetics_canary.canary_api_calls.name
  }
  tags = merge(local.tags, {
    application = "aws_synthetics_canary"
    Name        = "canary-alarm-${replace(local.domain_name, ".", "-")}"
  })

}

resource "aws_cloudwatch_metric_alarm" "canary_alarm_timeout" {
  provider                  = aws.aws_main
  alarm_name                = "canary-alarm-${replace(local.domain_name, ".", "-")}-timeout"
  comparison_operator       = "GreaterThanThreshold"
  period                    = local.cloudwatch_alarm_period
  evaluation_periods        = "1" // The number of periods over which data is compared to the specified threshold.
  metric_name               = "Duration"
  namespace                 = "CloudWatchSynthetics"
  statistic                 = "Average"
  datapoints_to_alarm       = "1"
  threshold                 = local.canary_timeout
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = [aws_sns_topic.email_http_ping.arn]
  alarm_actions             = [aws_sns_topic.email_http_ping.arn]
  ok_actions                = [aws_sns_topic.email_http_ping.arn]
  alarm_description         = "Canary alarm for - ${local.domain_name} timeout responce ${local.canary_timeout} milliseconds"
  dimensions = {
    CanaryName = aws_synthetics_canary.canary_api_calls.name
  }
  tags = merge(local.tags, {
    application = "aws_synthetics_canary"
    Name        = "canary-alarm-${replace(local.domain_name, ".", "-")}"
  })

}
