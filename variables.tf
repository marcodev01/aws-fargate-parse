variable "name" {
  description = "name of stack"
}

variable "aws-access-key" {
  type = string
}

variable "aws-secret-key" {
  type = string
}

variable "application-secrets" {
  description = "A map of secrets that is passed into the application. Formatted like ENV_VAR = VALUE"
  type        = map
}

variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
}


// OPTIONAL VARIABLES

variable "environment" {
  description = "environment: dev, test, prod"
  default     = "dev"
}

# variable "region" {
#   description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
#   default     = "eu-central-1"
# }

variable "aws-region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "availability_zones" {
  description = "list of availability zones, defaults to all AZ of the region"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "list of CIDRs for private subnets in VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "list of CIDRs for public subnets in VPC"
  default     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
  default     = 2
}

variable "container_port" {
  description = "port where Docker is exposed"
  default     = 8000
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  default     = 256
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 512
}

variable "health_check_path" { # TODO
  description = "Http path for task health check"
  default     = "/health"
}

