locals {
  topics = [
    for scheduler in var.schedulers : {
      name = scheduler.topic_name
    }
  ]

  queues = [
    for scheduler in var.schedulers : {
      name = scheduler.queue_name
      topics_to_subscribe = local.topics
    }
  ]

  subscriptions = {
    for sub in module.pubsub.local_subscriptions : sub.topic_name => sub
  }

  pubsub_schedulers = {
    for scheduler in var.schedulers : scheduler.name => {
      name = scheduler.name
      description = scheduler.description
      schedule_expression = scheduler.schedule_expression
      maximum_window_in_minutes = scheduler.maximum_window_in_minutes
      mode = scheduler.mode
      sns_topic_arn = local.subscriptions[scheduler.topic_name].topic_arn
      role_arn = aws_iam_role.sns_scheduler_role[scheduler.topic_name].arn
      input = scheduler.input
      timezone = scheduler.timezone
    }
  }
}

module "pubsub" {
  source = "github.com/paulo-tinoco/terraform-sns-topic-subscription"
  queues = local.queues
  topics = local.topics

  fifo = false

  account_id = var.account_id
}

resource "aws_scheduler_schedule" "sns_publish_scheduler" {
  for_each = local.pubsub_schedulers

  name = each.value.name
  description = each.value.description
  schedule_expression = each.value.schedule_expression
  target {
    arn = each.value.sns_topic_arn
    input = each.value.input
    role_arn = each.value.role_arn
  }
  flexible_time_window {
    mode = each.value.mode
    maximum_window_in_minutes = each.value.maximum_window_in_minutes
  }
  schedule_expression_timezone = each.value.timezone
}
