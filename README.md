# Event bridge SNS scheduler module

This terraform module creates one or more event bridge schedulers that send a message to a SNS topic.
It has a integration with a AWS pubsub module that creates a SNS topic, a SQS queue with a DLQ and a subscription between them. You just have to pass the topic and queue names and the module will create the subscription. 

## Usage

```hcl
module "event-bridge-sns-scheduler" {
  source = "github.com/inaciogu/event-bridge-sns-scheduler"
  schedulers = [ 
    {
      name = "test-scheduler"
      description = "This is a test scheduler"
      schedule_expression = "cron(10 17 * * ? *)"
      maximum_window_in_minutes = 60
      create_pubsub = true
      mode = "FLEXIBLE"
      topic_name = "example_topic"
      queue_name = "example_queue"
      input = "This is a test message"
    }
  ]

  account_id = "123456789012"
  region = "us-east-1"
}
```