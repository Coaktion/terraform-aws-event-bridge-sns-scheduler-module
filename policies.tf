resource "aws_iam_role" "sns_scheduler_role" {
  for_each = local.pubsub_schedulers

  name = "sns-scheduler-role-${each.key}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "sns_publish_policy" {
  for_each = local.pubsub_schedulers

  name = "sns-publish-policy-${each.key}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish"
        ]
        Effect   = "Allow"
        Resource = each.value.sns_topic_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sns_publish_policy_attachment" {
  for_each = local.pubsub_schedulers

  role       = aws_iam_role.sns_scheduler_role[each.key].name
  policy_arn = aws_iam_policy.sns_publish_policy[each.key].arn
}
