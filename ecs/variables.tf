variable "name" {
  description = "the name of stack"
}

variable "environment" {
  description = "the name of environment"
}

variable "region" {
  description = "the AWS region in which resources are created"
}

variable "subnets" {
  description = "List of subnet IDs"
}

variable "ecs_service_security_groups" {
  description = "Comma separated list of security groups"
}

variable "container_port" {
  description = "Port of container"
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
}

variable "aws_ecr_repository_url" {
  description = "Docker image to be launched"
}

variable "aws_alb_target_group_arn" {
  description = "ARN of the alb target group"
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
}

variable "container_environment_vars" {
  description = "The container environmnent variables"
  type        = list(object({ name = string, value = any }))
}

variable "container_secrets" {
  description = "The container ssm secret variables"
  type        = list(object({ name = string, valueFrom = string }))
}
