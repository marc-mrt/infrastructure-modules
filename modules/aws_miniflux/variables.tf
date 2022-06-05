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

variable "aws_snapshot_storage_tier" {
  description = "The storage sier for the EC2 instance's volume"
  type        = string
  default     = "archive"
}

variable "aws_instance_type" {
  description = "The AWS EC2 instance type"
  type        = string
  default     = "t2.nano"
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

# -------------------------------------------------------------------------------------------
# ------------------------------------------ SSH --------------------------------------------
# -------------------------------------------------------------------------------------------
variable "ssh_key_name" {
  description = "The SSH keyname to be associated to the EC2 instance"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------
# ---------------------------------------- MINIFLUX -------------------------------------------
# ---------------------------------------------------------------------------------------------
variable "domain" {
  description = "The domain used for all deployed infrastructure (will be used to name some components)"
  type        = string
}

variable "username" {
  description = "The miniflux admin username"
  type        = string
}

variable "password" {
  description = "The miniflux admin password"
  type        = string
}

variable "db_username" {
  description = "The miniflux's database user username"
  type        = string
}

variable "db_password" {
  description = "The miniflux's database user password"
  type        = string
}

variable "volume_size" {
  description = "The volume size"
  type        = number
  default     = 10
}

# ----------------------------------------------------------------------------------------------
# ---------------------------------------- NETWORKING ------------------------------------------
# ----------------------------------------------------------------------------------------------
variable "security_group_id" {
  description = "The security group ID to apply the necessary inbound/outbound rules"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID for the instance"
  type        = string
}
