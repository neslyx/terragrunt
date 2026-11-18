variable "parameters" {
  description = "Map of parameters in SSM Parameter Store"
  nullable    = false
  type        = map(string)
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}