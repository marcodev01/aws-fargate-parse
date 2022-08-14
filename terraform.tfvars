name                = "aws-fargate-parse-server"
environment         = "dev"
availability_zones  = ["eu-central-1a", "eu-central-1b"]
private_subnets     = ["10.0.0.0/24", "10.0.1.0/24"]
public_subnets      = ["10.0.3.0/24", "10.0.4.0/24"]
tsl_certificate_arn = "arn:aws:acm:eu-central-1:065927858371:certificate/efebb518-d630-45ba-8eab-b011f3f7c449"
