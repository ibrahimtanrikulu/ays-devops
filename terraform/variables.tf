variable "region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "eu-north-1"
}

variable "profile" {
  description = "The AWS profile to use for the provider"
  type        = string
  default     = "ays"
}

variable "engine_version" {
  description = "The version of the Aurora MySQL engine"
  type        = string
  default     = "8.0.mysql_aurora.3.04.1"
}
