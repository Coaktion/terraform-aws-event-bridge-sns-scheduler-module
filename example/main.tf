provider "aws" {
  region = ""
  access_key = ""
  secret_key = "" 
}

module "event-bridge-sns-scheduler" {
  source = "github.com/inaciogu/event-bridge-sns-scheduler"
  schedulers = [ 
    {
      name = "test-scheduler"
      description = "This is a test scheduler"
      schedule_expression = "cron(53 17 * * ? *)"
      mode = "OFF"
      sns_topic_arn = "arn:aws:sns:us-east-1:000000000:example_topic"
      input = "This is a test message"
      timezone = "America/Sao_Paulo"
    }
  ]
}