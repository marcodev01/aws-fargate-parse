### Amplify - for hosting your PWA ### 

resource "aws_amplify_app" "pwa" {
  name         = var.app_name
  repository   = var.app_repository
  access_token = var.repository_access_token

  # build spec for vue.js apps
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  # Redirects for Single Page Web Apps (SPA)
  # https://docs.aws.amazon.com/amplify/latest/userguide/redirects.html#redirects-for-single-page-web-apps-spa
  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }

  enable_branch_auto_build = true
  enable_branch_auto_deletion = true
}

resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.pwa.id
  branch_name = "master"
  display_name = "parse-demo-app"

  enable_auto_build = true 

  framework = "Vue.js"
  stage     = "DEVELOPMENT"
}