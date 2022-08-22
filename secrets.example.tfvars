# copy this file to secrets.tfvars and define your secrets
# you should never commit the secrets.tfvars file!

aws-access-key = "<AWS-ACCESS-KEY>"
aws-secret-key = "<AWS-SECRET-KEY>"
aws-account-id = "<AWS-ACCOUNT-ID>"

application_secrets = [
  {
    env  = "DATABASE_CONNECTION_URI",
    name = "/demo/database/uri",
    val  = "<DATABASE_CONNECTION_URI>",
    type = "SecureString"
  },
  {
    env  = "PARSE_MASTER_KEY",
    name = "/demo/parse-server/master_key",
    val  = "<PARSE_MASTER_KEY>",
    type = "SecureString"
  },
  {
    env  = "PARSE_APP_ID",
    name = "/demo/parse-server/app_id",
    val  = "<PARSE_APP_ID>",
    type = "String"
  }
]