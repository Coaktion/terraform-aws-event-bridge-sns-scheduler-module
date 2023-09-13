resource "aws_iam_role" "sns_scheduler_role" {
  name = "sns-publish-scheduler-role"
  
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
  name = "sns-publish-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sns_publish_policy_attachment" {
  role = aws_iam_role.sns_scheduler_role.name
  policy_arn = aws_iam_policy.sns_publish_policy.arn
}


resource "aws_scheduler_schedule" "sns_publish_scheduler" {
  for_each = { for scheduler in var.schedulers : scheduler.name => scheduler }

  name = each.value.name
  description = each.value.description
  schedule_expression = each.value.schedule_expression
  target {
    arn = each.value.sns_topic_arn
    input = each.value.input
    role_arn = aws_iam_role.sns_scheduler_role.arn
  }
  flexible_time_window {
    mode = each.value.mode
    maximum_window_in_minutes = each.value.maximum_window_in_minutes
  }
  schedule_expression_timezone = each.value.timezone

  depends_on = [ aws_iam_role_policy_attachment.sns_publish_policy_attachment ]
}
