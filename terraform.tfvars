name               = "aws-fargate-parse-server"
environment        = "dev"
availability_zones = ["eu-central-1a", "eu-central-1b"]
private_subnets    = ["10.0.0.0/24", "10.0.1.0/24"]
public_subnets     = ["10.0.3.0/24", "10.0.4.0/24"]
container_port     = 1337
health_check_path  = "/parse/health"
#atlasorgid         = "Marc's Org - 2022-08-14"
#atlas_project_id   = "ProjectCAS"
#atlas_cluster_name = "CASProject"
#aws_account_id     = "065927858371"

aws-access-key           = "AKIAQ6WM3JDB7AQY77YJ"
aws-secret-key           = "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"