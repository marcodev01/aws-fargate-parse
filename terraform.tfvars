name                  = "aws-fargate-parse-server"
environment           = "dev"
availability_zones    = ["eu-central-1a", "eu-central-1b"]
private_subnets       = ["10.0.0.0/24", "10.0.1.0/24"]
public_subnets        = ["10.0.3.0/24", "10.0.4.0/24"]
container_port        = 1337
parse_mount_path      = "/parse"
dashboard_mount_path  = "/dashboard"
// for demo purpouses http only is configured. Never use this setting for production!
alb_tls_cert_arn      = null