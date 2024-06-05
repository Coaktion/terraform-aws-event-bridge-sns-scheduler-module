provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

module "scheduler" {
  source = "../" # "github.com/Coaktion/terraform-aws-event-bridge-sns-scheduler-module"
  schedulers = [
    {
      name                = "test-scheduler"
      description         = "This is a test scheduler"
      schedule_expression = "cron(53 17 * * ? *)"
      mode                = "OFF"
      create_pubsub       = true
      queue_name          = "test-queue"
      topic_name          = "test-topic"
      input               = "test-input"
      timezone            = "America/Sao_Paulo"
    },
    {
      name                = "test-scheduler-2"
      description         = "This is a test 2"
      schedule_expression = "cron(11 17 * * ? *)"
      mode                = "OFF"
      create_pubsub       = false
      queue_name          = "test-queue"
      topic_name          = "test-topic"
      input = jsonencode({
        "test" = "test"
      })
      timezone = "America/Sao_Paulo"
    }
  ]
  account_id = ""
  region     = "us-east-1"
}
