# ./modules/secretsmanager/main.tf

resource "random_password" "db_password" {
  length  = 32
  special = false
}
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "db_master_credentials_${random_string.suffix.result}"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "aysroot"
    password = random_password.db_password.result
  })
}

output "db_username" {
  value = "aysroot"
}

output "db_password" {
  value = random_password.db_password.result
}

output "secret_arn" {
  value = aws_secretsmanager_secret.db_credentials.arn
}

output "secret_version" {
  value = aws_secretsmanager_secret_version.db_credentials_version.version_id
}
