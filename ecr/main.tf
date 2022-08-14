# ECR - Elastic Container Registry 
# a place where the docker image can be pulled from by the ECS service
resource "aws_ecr_repository" "main" {
  name                 = "${var.name}-${var.environment}"
  image_tag_mutability = "MUTABLE" // this is necessary in order to put a latest tag on the most recent image

  image_scanning_configuration {
    scan_on_push = false // should be activated for production use?: https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html
  }
}

# LIFECYCLE POLICY 
# Make sure don’t keep too many versions of image as with every new deployment of the application, a new image would be created
resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images only"
      action       = {
        type = "expire"
      }
      selection     = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}

output "aws_ecr_repository_url" {
    value = aws_ecr_repository.main.repository_url
}