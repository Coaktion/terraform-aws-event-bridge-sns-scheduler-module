variable "schedulers" {
  description = "List of schedulers to create"
  type = list(object({
    name = string
    description = optional(string)
    schedule_expression = string
    maximum_window_in_minutes = optional(number) // 1 - 1440
    mode = string // ALLOWED_VALUES = ["OFF", "FLEXIBLE"]
    sns_topic_arn = string // Just standard SNS topics are allowed by the scheduler
    input = optional(string)
    timezone = optional(string) // default = UTC
  }))
}