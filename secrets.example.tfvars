# copy this file to secrets.tfvars and define your secrets
# you should never commit the secrets.tfvars file!

aws-access-key = "<AWS-ACCESS-KEY>"
aws-secret-key = "<AWS-SECRET-KEY>"
aws-account-id = "<AWS-ACCOUNT-ID>"

application_secrets = [
  {
    env  = "PARSE_SERVER_DATABASE_URI",
    name = "/demo/database/uri",
    val  = "<PARSE_SERVER_DATABASE_URI>",
    type = "SecureString"
  },
  {
    env  = "PARSE_SERVER_MASTER_KEY",
    name = "/demo/parse-server/master_key",
    val  = "<PARSE_SERVER_MASTER_KEY>",
    type = "SecureString"
  },
  {
    env  = "PARSE_SERVER_APPLICATION_ID",
    name = "/demo/parse-server/app_id",
    val  = "<PARSE_SERVER_APPLICATION_ID>",
    type = "String"
  }
]