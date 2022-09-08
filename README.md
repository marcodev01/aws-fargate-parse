# aws-fargate-parse
IaC by terraform specification to create cloud infrastructure for running dockerized parse-server on aws.

## Architecure
TODO

# Getting started
1. install **terraform-cli** 
1. install **aws-cli**
    - configure your crendentials in aws-cli: `aws configure`

## Preconditions
- Existing (empty) database e.g. DBaaS [MongoDB Atlas](https://www.mongodb.com/atlas/database)
    - Note: Parse Sever supports MongoDB or PostgreSQL as a database
- Domain which you control (Requesting SSL/TLS certificates for domains that you don’t control violates the [AWS Service Terms](https://aws.amazon.com/de/service-terms/)).
- Valid SSL/TLS certificate for your domain - either created by ACM ([AWS Certificate Manager](https://aws.amazon.com/de/certificate-manager/)) or in case of an existing one it needs to be imported to ACM. 

## Create AWS infrastructure
1. Create your own `secrets.tfvars` based on `secrets.example.tfvars` and replace the `<PLACEHOLDER>` values.
1. Execute `terraform init` to initialize a configuration directory and to download and install the providers defined in the configuration.
1. Execute `terraform plan -var-file="secrets.tfvars" -var-file="terraform.tfvars" -out="tfplan.plan"` to calculate the changes terraform has to apply and create a plan.
1. Execute changes by `terraform apply tfplan.plan` to setup the cloud infrastructure in aws
1. Push your docker image to the newly created AWS ECR repository - the image will be automatically deployed on infrastructure setup
1. Configure route forwarding for your domain to the newly created AWS load balancer

### Outputs
After applying the infrstructure some information can be displayed by: `terraform output`.
- `aws_lb_dns`: DNS of load balancer to access the parse server. 
- `aws_nat_public_ip_list`: Public IPs of created NAT Gateways four outbound traffic. These IPs are defined as elastic IPs and do not change while runnning the infrastructure.

Note: If you are using the free tier M0 of MongoDB Atlas you need to manually specify the ip access list by adding IP adresses of the created NAT Gateways.

### Deploy new Docker image version
1. Push new image version with tag `latest` to AWS ECR
1. To trigger AWS ECS deployment execute: `aws ecs update-service --cluster aws-fargate-parse-server-cluster-dev --service aws-fargate-parse-server-service-dev --force-new-deployment`


## Destroy AWS infrastructure
1. Create plan to destroy infrastructure: `terraform plan -destroy -var-file="secrets.tfvars" -var-file="terraform.tfvars" -out="tfdestroy.plan"`
1. Delete images from ECR (otherwise destruction of ECR by terraform will fail)
1. Destroy infrastructure by: `terraform apply tfdestroy.plan`
1. If necessery delete manually protocol groups in CloudWatch

# App hosting
- For simple PWA (Progressive Web App) hosting **AWS Amplify** is configured by terraform in this setup. You need to specify a *repository url* and *acess key* in `*.tfvars`. The build and deployment is automatically managed by Amplify (except on infrastructure setup - see [Known issues](#known-issues)).
- If you need to serve static ressources only, AWS S3 with SSL/TLS secured CloudFront is recommended. Reference: https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html. 

Delete or replace the terraform *amplify module* for project tailored App setup.


# Known issues
- It is recommended to set up DB connection by [VPC Peering](https://www.mongodb.com/docs/atlas/security-vpc-peering/) or [AWS PrivateLink](https://aws.amazon.com/de/blogs/apn/connecting-applications-securely-to-a-mongodb-atlas-data-plane-with-aws-privatelink/). Those connection types are supported by MongoDB Atlas dedicated clusters (M10 and above) only. Since free tier cluster M0 is used for this example project either VPC Peering nor AWS PrivateLink is set up currently by terraform. Implement recommended DB connection for production use!   
- Currently there is a bug when setting up AWS Amplify by Terraform - the first intial deployment has to be triggered manually in the amplify console. However, all subsequent pushes to the repository will deployed automatically. Reference: https://github.com/hashicorp/terraform-provider-aws/issues/19870


