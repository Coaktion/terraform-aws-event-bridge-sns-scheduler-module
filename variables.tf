variable "schedulers" {
  description = "List of schedulers to create"
  type = list(object({
    name                      = string
    description               = optional(string)
    schedule_expression       = string
    maximum_window_in_minutes = optional(number) // 1 - 1440
    mode                      = string           // ALLOWED_VALUES = ["OFF", "FLEXIBLE"]
    topic_name                = string           // Just standard SNS topics are allowed by the scheduler
    queue_name                = string           // Just standard SQS queues are allowed by the scheduler
    input                     = optional(string)
    timezone                  = optional(string) // default = UTC
    create_pubsub             = optional(bool)   // default = false
  }))
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}
