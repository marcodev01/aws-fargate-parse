### AWS INFRASTRUCTURE VARS ###
name               = "aws-fargate-parse-server"
environment        = "dev"
availability_zones = ["eu-central-1a", "eu-central-1b"]
private_subnets    = ["10.0.0.0/24", "10.0.1.0/24"]
public_subnets     = ["10.0.3.0/24", "10.0.4.0/24"]
alb_tls_cert_arn   = null // for demo purpouses http only is configured. Never use this setting for production!

### PARSE SERVER VARS ###
container_port       = 1337
parse_mount_path     = "/parse"
dashboard_mount_path = "/dashboard"


### PWA VARS (vue.js related) ###
app_repository = "https://github.com/marcodev01/parse-client-demo"
app_name       = "parse-client-demo"
