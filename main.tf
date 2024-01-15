locals {
  queues = [
    for scheduler in var.schedulers : {
      name = scheduler.queue_name
      topics_to_subscribe = [
        {
          name = scheduler.topic_name
        }
      ]
    } if scheduler.create_pubsub == true
  ]

  subscriptions = {
    for sub in module.pubsub.local_subscriptions : sub.topic_name => sub
  }

  topic_prefix = "arn:aws:sns:${var.region}:${var.account_id}:"

  pubsub_schedulers = {
    for scheduler in var.schedulers : scheduler.name => {
      name                      = scheduler.name
      description               = scheduler.description
      schedule_expression       = scheduler.schedule_expression
      maximum_window_in_minutes = scheduler.maximum_window_in_minutes
      mode                      = scheduler.mode
      topic_name                = scheduler.topic_name
      sns_topic_arn             = scheduler.create_pubsub ? local.subscriptions[scheduler.topic_name].topic_arn : "${local.topic_prefix}${scheduler.topic_name}"
      input                     = scheduler.input
      timezone                  = scheduler.timezone
    }
  }
}

module "pubsub" {
  source = "github.com/Coaktion/terraform-aws-pubsub-module"
  queues = local.queues

  fifo = false

  account_id = var.account_id
}

resource "aws_scheduler_schedule" "sns_publish_scheduler" {
  for_each = local.pubsub_schedulers

  name                = each.value.name
  description         = each.value.description
  schedule_expression = each.value.schedule_expression
  target {
    arn      = each.value.sns_topic_arn
    input    = each.value.input
    role_arn = aws_iam_role.sns_scheduler_role[each.key].arn
  }
  flexible_time_window {
    mode                      = each.value.mode
    maximum_window_in_minutes = each.value.maximum_window_in_minutes
  }
  schedule_expression_timezone = each.value.timezone
}
