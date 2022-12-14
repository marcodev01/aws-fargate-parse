variable "name" {
  description = "name of stack"
  type        = string
}

variable "aws-access-key" {
  sensitive = true
  type      = string
}

variable "aws-secret-key" {
  sensitive = true
  type      = string
}

variable "aws-account-id" {
  sensitive = true
  type      = string
}

variable "application_secrets" {
  sensitive   = true
  description = "an object of secrets that is passed into the container"
  type        = list(object({ env = string, name = string, val = string, type = string }))
}

variable "container_port" {
  description = "port where Docker is exposed"
  type        = number
}

variable "parse_mount_path" {
  description = "path on which Parse API is served, e.g.' /parse'"
  type        = string
}

variable "dashboard_mount_path" {
  description = "path on which Parse Dashboard is served, e.g.' /dashboard'"
  type        = string
}

variable "parse_server_url" {
  description = "https url to access parse server"
  type        = string
}

variable "alb_tls_cert_arn" {
  description = "ARN of the certificate used by the https listener of the ALB"
  type        = string
}

// DEFAULT VARIABLES

variable "app_repository" {
  description = "url of the app repository"
  type        = string
  default     = null
}

variable "repository_access_token" {
  description = "url of the app repository"
  type        = string
  default     = null
}

variable "app_name" {
  description = "name of the app front-end"
  type        = string
  default     = null
}
variable "environment" {
  description = "environment: e.g. dev, test, ref, prod"
  type        = string
  default     = "dev"
}

variable "aws-region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "availability_zones" {
  description = "list of availability zones, defaults to all AZ of the region"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "list of CIDRs for private subnets in VPC"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "list of CIDRs for public subnets in VPC"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
  type        = number
  default     = 2
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = number
  default     = 512
}
