variable "name" {
  description = "the name of stack"
}

variable "environment" {
  description = "the name of environment"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}

#variable "mongodbatlas_network_peering_connection_id" {
#  description = "mongodbatlas_network_peering_connection_id"
#}
