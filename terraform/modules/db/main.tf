variable "region" {
  description = "AWS region"
  type        = string
}

variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Default security group id"
  type        = list(string)
}


variable "master_username" {
  description = "Master username for the RDS cluster"
  type        = string
}

variable "master_password" {
  description = "Master password for the RDS cluster"
  type        = string
}

variable "engine_version" {
  description = "Engine version for the RDS cluster"
  type        = string
}


provider "aws" {
  alias   = "db"
  region  = var.region
  profile = var.profile
}



# Create the Aurora DB cluster
resource "aws_rds_cluster" "aurora" {
  cluster_identifier        = "aurora-cluster"
  engine                    = "aurora-mysql"
  engine_version            = var.engine_version
  # engine_mode               = "serverless" #["global" "multimaster" "parallelquery" "provisioned" "serverless"]
  master_username           = var.master_username
  master_password           = var.master_password
  backup_retention_period   = 1
  preferred_backup_window   = "07:00-09:00"
  vpc_security_group_ids    = var.security_group_ids
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  storage_encrypted         = false
  skip_final_snapshot       = true
  snapshot_identifier       = null
  final_snapshot_identifier = null

  serverlessv2_scaling_configuration {
    min_capacity = 1
    max_capacity = 128
  }

  tags = {
    Name = "aurora-cluster"
  }
}

# Create a DB subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "aurora-subnet-group"
  }
}

output "db_cluster_id" {
  value = aws_rds_cluster.aurora.id
}