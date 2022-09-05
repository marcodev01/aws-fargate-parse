# copy this file to secrets.tfvars and define your secrets
# you should never commit the secrets.tfvars file!

aws-access-key = "<AWS-ACCESS-KEY>"
aws-secret-key = "<AWS-SECRET-KEY>"
aws-account-id = "<AWS-ACCOUNT-ID>"

repository_access_token = "<ACCESS-TOKEN>"

application_secrets = [
  {
    env  = "PARSE_SERVER_DATABASE_URI",
    name = "/<ENVIRONMENT>/database/uri",
    val  = "<PARSE_SERVER_DATABASE_URI>",
    type = "SecureString"
  },
  {
    env  = "PARSE_SERVER_MASTER_KEY",
    name = "/<ENVIRONMENT>/parse-server/master_key",
    val  = "<PARSE_SERVER_MASTER_KEY>",
    type = "SecureString"
  },
  {
    env  = "PARSE_READ_ONLY_MASTER_KEY",
    name = "/<ENVIRONMENT>/parse-server/read_only_master_key",
    val  = "<READ_ONLY_MASTER_KEY>",
    type = "SecureString"
  },
  {
    env  = "PARSE_SERVER_APPLICATION_ID",
    name = "/<ENVIRONMENT>/parse-server/app_id",
    val  = "<PARSE_SERVER_APPLICATION_ID>",
    type = "String"
  }
]