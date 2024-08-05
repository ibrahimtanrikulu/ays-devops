variable "profile" {
  description = "The AWS profile to use for the provider"
  type        = string
}

provider "aws" {
  alias   = "iam"
  profile = var.profile
}


resource "random_string" "ecs_task_role_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "ecs_service_role_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role_${random_string.ecs_task_role_suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

}

resource "aws_iam_role" "ecs_service_role" {
  name = "ecs_service_role_${random_string.ecs_service_role_suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_policy_attachment" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "ecs_service_role_arn" {
  value = aws_iam_role.ecs_service_role.arn
}
