resource "aws_sns_topic" "email_http_ping" {
  provider        = aws.aws_main
  name            = "email-http-ping"
  tags            = local.tags
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    },
    "defaultRequestPolicy": {
      "headerContentType": "text/plain; charset=UTF-8"
    }
  }
}
EOF
}

resource "aws_sns_topic_subscription" "email_http_ping" {
  provider               = aws.aws_main
  for_each               = local.subscribers
  topic_arn              = aws_sns_topic.email_http_ping.arn
  protocol               = local.subscribers[each.key].protocol
  endpoint               = local.subscribers[each.key].endpoint
  endpoint_auto_confirms = local.subscribers[each.key].endpoint_auto_confirms
}


data "aws_iam_policy_document" "email_http_ping" {
  provider  = aws.aws_main
  policy_id = "__default_policy_ID"
  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        local.account_id,
      ]
    }
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      aws_sns_topic.email_http_ping.arn,
    ]
    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_policy" "email_http_ping" {
  provider = aws.aws_main
  arn      = aws_sns_topic.email_http_ping.arn
  policy   = data.aws_iam_policy_document.email_http_ping.json
}
