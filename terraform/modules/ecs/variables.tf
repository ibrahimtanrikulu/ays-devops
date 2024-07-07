variable "region" {
  description = "The AWS region to deploy the resources in"
  type        = string
}

variable "profile" {
  description = "The AWS profile to use for the provider"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the ECS cluster will be created"
  type        = string
}

variable "public_subnets" {
  description = "The public subnets where the ECS resources will be created"
  type        = list(string)
}
