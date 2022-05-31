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
variable "ssh_cdir_blocks" {
  description = "The IPv4 cdir block to ingress the instance via SSH"
  type        = list(string)
}

variable "ssh_public_key" {
  description = "A public SSH key to be used to connect to EC2 instances"
  type        = string
}

# ----------------------------------------------------------------------------------------------
# ---------------------------------------- SYNCTHING -------------------------------------------
# ----------------------------------------------------------------------------------------------
variable "domain" {
  description = "The domain used for all deployed infrastructure"
  type        = string
}

variable "volume_size" {
  description = "The volume size"
  type        = number
  default     = 10
}

variable "instance_parameters" {
  description = "EC2's instance parameters, accessible via ssm"
  type = set(object({
    name  = string
    value = string
  }))
}

variable "secrets_path" {
  description = "SSM's path to use to store secrets to be accessible in the EC2 instance"
  type        = string
}
