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
