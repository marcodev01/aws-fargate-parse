/*
variable "name" {
  description = "the name of stack"
}

variable "environment" {
  description = "the name of environment"
}

variable "application-secrets" {
  description = "A map of secrets that is passed into the application. Formatted like ENV_VAR = VALUE"
  type        = map
}
*/

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
