
resource "aws_ssm_parameter" "secret" {
  count = length(var.application_secrets)

  name = var.application_secrets[count.index].name
  type = var.application_secrets[count.index].type
  value = var.application_secrets[count.index].val

  tags = {
    environment = var.environment
  }
}

locals {
  secretMap = [for secret in var.application_secrets : {
      "name"      : "${secret.env}",
      "valueFrom" : "arn:aws:ssm:${var.aws-region}:${var.aws-account-id}:parameter${secret.name}"
    }
  ]
}




# This file creates secrets in the AWS Secret Manager
# Note that this does not contain any actual secret values
# make sure to not commit any secret values to git!
# you could put them in secrets.tfvars which is in .gitignore

/*
resource "aws_secretsmanager_secret" "application_secrets" {
  count = length(var.application-secrets)
  name  = "${var.name}-application-secrets-${var.environment}-${element(keys(var.application-secrets), count.index)}"
}


resource "aws_secretsmanager_secret_version" "application_secrets_values" {
  count         = length(var.application-secrets)
  secret_id     = element(aws_secretsmanager_secret.application_secrets.*.id, count.index)
  secret_string = element(values(var.application-secrets), count.index)
}

locals {
  secrets = zipmap(keys(var.application-secrets), aws_secretsmanager_secret_version.solaris_broker_application_secrets_values.*.arn)

  secretMap = [for secretKey in keys(var.application-secrets) : {
    name      = secretKey
    valueFrom = lookup(local.secrets, secretKey)
    }

  ]
}

output "application_secrets_arn" {
  value = aws_secretsmanager_secret_version.solaris_broker_application_secrets_values.*.arn
}

output "secrets_map" {
  value = local.secretMap
}
*/