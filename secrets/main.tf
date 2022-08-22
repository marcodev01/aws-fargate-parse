
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
