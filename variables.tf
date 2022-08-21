variable "name" {
  description = "name of stack"
}

variable "aws-access-key" {
  sensitive = true
  type      = string
}

variable "aws-secret-key" {
  sensitive = true
  type      = string
}

#variable "application-secrets" {
#  description = "A map of secrets that is passed into the application. Formatted like ENV_VAR = VALUE"
#  type        = map(any)
#}

variable "container_port" {
  description = "port where Docker is exposed"
}

variable "health_check_path" {
  description = "Http path for task health check"
}

// OPTIONAL VARIABLES

variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
  default     = "UNDEFINED" # not used
}

variable "environment" {
  description = "environment: dev, test, prod"
  default     = "dev"
}

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

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  default     = 256
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 512
}

variable "parse_app_id" {
  description = "app id of parse server"
}

variable "parse_master_key" {
  description = "master key of parse server"
}

variable "data_base_uri" {
  description = "uri of connecting database"
}

variable "parse_server_url" {
  description = "url of parse server"
}
