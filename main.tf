terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.25.0"
    }
  }
}


provider "aws" {
  alias = "aws"
  region     = var.aws-region
  access_key = var.aws-access-key
  secret_key = var.aws-secret-key
}

provider "mongodbatlas" {
  alias = "mongodbatlas"
  public_key  = var.mongodbatlas_public_key
  private_key = var.mongodbatlas_private_key
}

module "db" {
  source             = "./db"
  providers = {
      mongodbatlas = mongodbatlas,
      aws = aws
  }
  atlasorgid         = var.atlasorgid
  atlas_project_id   = var.atlas_project_id
  atlas_cluster_name = var.atlas_cluster_name
  aws_region         = var.aws-region
  atlas_dbuser       = var.atlas_dbuser
  atlas_dbpassword   = var.atlas_dbpassword
  cidr               = var.cidr
  aws_account_id     = var.aws_account_id
  vpc_id              = module.vpc.id
  nat_gateway_public_ip = module.vpc.nat_gateway_public_ip
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
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  alb_tls_cert_arn    = var.tsl_certificate_arn
  health_check_path   = var.health_check_path
}

module "ecr" {
  source      = "./ecr"
  name        = var.name
  environment = var.environment
}


# module "secrets" {
#  source              = "./secrets"
#  name                = var.name
#  environment         = var.environment
#  application-secrets = var.application-secrets
# }

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
  container_environment = [
    { name = "LOG_LEVEL",
    value = "DEBUG" },
    { name = "PORT",
    value = var.container_port }
  ]
  aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
  // container_secrets      = module.secrets.secrets_map
  // container_secrets_arns = module.secrets.application_secrets_arn
}

