variable "application_secrets" {
  sensitive   = true
  description = "A object of secrets that is passed into the container"
}

variable "aws-region" {
  description = "AWS region"
}

variable "aws-account-id" {
  sensitive = true
}

variable "environment" {
  description = "the name of environment"
}
