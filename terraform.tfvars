### AWS INFRASTRUCTURE VARS ###
name               = "aws-fargate-parse-server"
environment        = "dev"
availability_zones = ["eu-central-1a", "eu-central-1b"]
private_subnets    = ["10.0.0.0/24", "10.0.1.0/24"]
public_subnets     = ["10.0.3.0/24", "10.0.4.0/24"]
alb_tls_cert_arn   = "arn:aws:acm:eu-central-1:065927858371:certificate/9cd2f7a0-acf7-405e-9845-e2759a798324"

### PARSE SERVER VARS ###
container_port        = 1337
parse_mount_path      = "/parse"
dashboard_mount_path  = "/dashboard"
parse_server_url      = "https://server.awesome42.de/parse"


### PWA VARS (vue.js related) ###
app_repository = "https://github.com/marcodev01/parse-client-demo"
app_name       = "parse-client-demo"
