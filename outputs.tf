output "scheduler" {
  value = aws_scheduler_schedule.sns_publish_scheduler
}

output "subscriptions" {
  value = module.pubsub.local_subscriptions
}

output "queues" {
  value = local.queues
}

output "iam" {
  value = aws_iam_role.sns_scheduler_role
}

output "local_subscriptions" {
  value = local.subscriptions
}