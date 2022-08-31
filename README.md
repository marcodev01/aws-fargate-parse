# aws-fargate-parse
IaC by terraform specification to create cloud infrastructure for running dockerized parse-server on aws.

## Architecure
TODO

# Getting started
1. install terraform cli 
1. Install aws-cli
    - configure aws-cli with your crendentials: `aws configure`
1. setup your own database or use an existing database, e.g. DBaaS [MongoDB Atlas](https://www.mongodb.com/atlas/database)
    - Note: Parse Sever supports MongoDB or PostgreSQL as a database
1. create your own `secrets.tfvars` based on `secrets.example.tfvars` and replace the `<PLACEHOLDER>` values.
1. execute `terraform init` to initialize a configuration directory and to download and install the providers defined in the configuration.
1. execute `terraform plan -var-file="secrets.tfvars" -var-file="terraform.tfvars" -out="tfplan.plan"` to calculate the changes terraform has to apply and create a plan.
1. execute changes by `terraform apply tfplan.plan` to setup the cloud infrastructure in aws
1. push your docker image to the created AWS ECR repository - this will trigger an automatic deployment in AWS ECS

## Outputs
After applying the infrstructure some information can be displayed by: `terraform output`.
- `aws_lb_dns`: DNS of load balancer to access the parse server API. Note: only HTTP is configured, to use HTTPS you need to use a user owned domain with tls certificate.
- `aws_nat_public_ip_list`: Public IPs of created NAT Gateways four outbound traffic. These IPs are defined as elastic IPs and do not change while runnning the infrastructure.

If your using the free tier M0 of [MongoDB Atlas](https://www.mongodb.com/atlas/database) you need to manually specify the ip access list by adding IP adresses of your created NAT Gateways.
Best practice would be a DB connection by VPC peering or AWS private private link - unfortunatelly this supported only by dedicated-tier (M10 and above) clusters.

## Destroy
1. Create plan to destroy infrastructure: ``terraform plan -destroy -var-file="secrets.tfvars" -var-file="terraform.tfvars" -out="tfdestroy.plan"`
1. Delete images from ECR
1. Destroy your infrastructure by: `terraform apply tfdestroy.plan`
1. If necessery destroy manually protocol groups in CloudWatch

