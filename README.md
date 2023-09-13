# Event bridge SNS scheduler module

This terraform module creates one or more event bridge schedulers that send a message to a SNS topic.

## Usage

```hcl
module "event-bridge-sns-scheduler" {
  source = "../"
  schedulers = [ 
    {
      name = "test-scheduler"
      description = "This is a test scheduler"
      schedule_expression = "cron(10 17 * * ? *)"
      maximum_window_in_minutes = 60
      mode = "FLEXIBLE"
      sns_topic_arn = "arn:aws:sns:${region}:${account_id}:example_topic"
      input = "This is a test message"
    }
  ]
}
```