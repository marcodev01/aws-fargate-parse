variable "name" {
  description = "the name of stack"
}

variable "environment" {
  description = "the name of environment"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "container_port" {
  description = "Ingres and egress port of the container"
}
