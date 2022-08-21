output "container_secrets" {
  value = tolist([var.parse_app_id, var.parse_master_key, var.data_base_uri, var.parse_server_url])
}