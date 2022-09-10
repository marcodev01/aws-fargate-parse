terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.26.0"
    }
  }
}

provider "aws" {
  alias      = "aws"
  region     = var.aws-region
  access_key = var.aws-access-key
  secret_key = var.aws-secret-key
}

module "amplify" {
  source                  = "./amplify"
  app_repository          = var.app_repository
  repository_access_token = var.repository_access_token
  app_name                = var.app_name
}

module "vpc" {
  source             = "./vpc"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "security_groups" {
  source         = "./security-groups"
  name           = var.name
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}

module "alb" {
  source              = "./alb"
  name                = var.name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  container_port      = var.container_port
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  health_check_path   = "${var.parse_mount_path}/health"
  alb_tls_cert_arn    = var.alb_tls_cert_arn
}

module "ecr" {
  source      = "./ecr"
  name        = var.name
  environment = var.environment
}


module "secrets" {
  source              = "./secrets"
  application_secrets = var.application_secrets
  aws-region          = var.aws-region
  aws-account-id      = var.aws-account-id
  environment         = var.environment
}

module "ecs" {
  source                      = "./ecs"
  name                        = var.name
  environment                 = var.environment
  region                      = var.aws-region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  container_environment_vars = [
    { name = "LOG_LEVEL", value = "DEBUG" },
    { name = "PORT", value = var.container_port },
    { name = "PARSE_SERVER_URL", value = var.parse_server_url },
    { name = "PARSE_MOUNT_PATH", value = var.parse_mount_path },
    { name = "DASHBOARD_MOUNT_PATH", value = var.dashboard_mount_path },
    { name = "PARSE_SERVER_APP_NAME", value = "${var.name}_${var.environment}" }
  ]
  aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
  container_secrets      = module.secrets.container_ssm_secrets_map
}
