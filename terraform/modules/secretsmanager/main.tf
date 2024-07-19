# Configure the AWS provider
provider "aws" {
  region  = var.region
  profile = var.profile
}

# Retrieve the secret metadata
data "aws_secretsmanager_secret" "example" {
  arn = "arn:aws:secretsmanager:eu-central-1:962231853120:secret:ays-database/production/mysql-jOfXoM"
}

# Retrieve the secret value
data "aws_secretsmanager_secret_version" "example" {
  secret_id = data.aws_secretsmanager_secret.example.id
  # version_stage = "AWSCURRENT"  # Optional, default is AWSCURRENT
}

# Output the secret values
output "secret_values" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)
  sensitive = true # Mark the output as sensitive to hide it in the output
}

# Output individual secret values
output "username" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["username"]
  sensitive = true
}

output "password" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["password"]
  sensitive = true
}

output "engine" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["engine"]
  sensitive = true
}

output "host" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["host"]
  sensitive = true
}

output "port" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["port"]
  sensitive = true
}

output "db_instance_identifier" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.example.secret_string)["dbInstanceIdentifier"]
  sensitive = true
}
