# ----------------------------------------------------------------------------------------
# ---------------------------------------- AWS -------------------------------------------
# ----------------------------------------------------------------------------------------
variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "aws_availability_zone" {
  description = "The AWS availability zone for the deployed infrastructure"
  type        = string
}

# ------------------------------------------------------------------------------------------------
# ---------------------------------------- ENVIRONMENT -------------------------------------------
# ------------------------------------------------------------------------------------------------
variable "project" {
  description = "The project for which the infrastructure is deployed"
  type        = string
}

variable "environment" {
  description = "The project's name for which the infrastructure is deployed"
  type        = string
}

variable "owner" {
  description = "The provider of the infrastructure's configuration"
  type        = string
}

# -----------------------------------------------------------------------------------------------
# ---------------------------------------- NETWORKING -------------------------------------------
# -----------------------------------------------------------------------------------------------
variable "vpc_cdir_block" {
  description = "The VPC's cdir block"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_cdir_block" {
  description = "The subnet's cdir block"
  type        = string
  default     = "10.10.101.0/24"
}
