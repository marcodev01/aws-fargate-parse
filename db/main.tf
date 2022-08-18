terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

resource "mongodbatlas_project" "aws_atlas" {
  name   = "aws-atlas"
  org_id = var.atlasorgid
}

resource "mongodbatlas_cluster" "cluster" {
  project_id   = var.atlas_project_id // Your mongodb atlas project id
  name         = var.atlas_cluster_name // Desired cluster name

  auto_scaling_disk_gb_enabled = false
  mongo_db_major_version = "5.0"

  //Provider Settings "block"
  provider_name = "AWS"
  provider_instance_size_name = "M0"
  provider_region_name        = var.aws_region
}


resource "mongodbatlas_database_user" "db-user" {
  username           = var.atlas_dbuser
  password           = var.atlas_dbpassword
  auth_database_name = "admin"
  project_id         = mongodbatlas_project.aws_atlas.id
  roles {
    role_name     = "readWrite"
    database_name = "admin"
  }
  depends_on = [mongodbatlas_project.aws_atlas]
}

resource "mongodbatlas_network_container" "atlas_container" {
  atlas_cidr_block = var.cidr
  project_id       = mongodbatlas_project.aws_atlas.id
  provider_name    = "AWS"
  region_name      = var.aws_region
}


# tflint-ignore: terraform_unused_declarations
data "mongodbatlas_network_container" "atlas_container" {
  container_id = mongodbatlas_network_container.atlas_container.container_id
  project_id   = mongodbatlas_project.aws_atlas.id
}

resource "mongodbatlas_network_peering" "aws-atlas" {
  accepter_region_name   = var.aws_region
  project_id             = mongodbatlas_project.aws_atlas.id
  container_id           = mongodbatlas_network_container.atlas_container.container_id
  provider_name          = "AWS"
  route_table_cidr_block = var.cidr
  vpc_id                 = var.vpc_id
  aws_account_id         = var.aws_account_id
}

resource "mongodbatlas_project_ip_access_list" "test" {
  project_id = mongodbatlas_project.aws_atlas.id
  cidr_block = var.cidr
  comment    = "cidr block for AWS VPC"
}

output "mongodbatlas_network_peering_connection_id" {
  value = mongodbatlas_network_peering.aws-atlas.connection_id
}