# SECURITY GROUP for the ALB
resource "aws_security_group" "alb" {
  name   = "${var.name}-sg-alb-${var.environment}"
  description = "ALB allows only access via TCP ports 80 and 443"
  vpc_id = var.vpc_id

  ingress { // ingress on port 80 from any ip adress
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress { // ingress on port 443 from any ip adress
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress { // egress from and to any port from any ip adress
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.name}-sg-alb-${var.environment}"
    Environment = var.environment
  }
}


# SECURITY GROUP for the ECS task (house our container)
resource "aws_security_group" "ecs_tasks" {
  name   = "${var.name}-sg-task-${var.environment}"
  description = "ALB allows ingress access only to port that is exposed by the current task"
  vpc_id = var.vpc_id

  ingress { // ingress only to port that is exposed
    protocol         = "tcp"
    from_port        = var.container_port
    to_port          = var.container_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress { // egress from and to any port from any ip adress
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.name}-sg-task-${var.environment}"
    Environment = var.environment
  }
}

output "alb" {
  value = aws_security_group.alb.id
}

output "ecs_tasks" {
  value = aws_security_group.ecs_tasks.id
}