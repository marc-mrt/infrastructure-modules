# ----------------------------------------------------------------------------------------
# ---------------------------------------- AWS -------------------------------------------
# ----------------------------------------------------------------------------------------
variable "aws_region" {
  description = "The AWS region"
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

# ------------------------------------------------------------------------------------------------
# ---------------------------------------- CERTIFICATE -------------------------------------------
# ------------------------------------------------------------------------------------------------
variable "route53_zone_id" {
  description = "The R53 Zone ID to run validation of the ceritificate"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the certificate (e.g. example.org)"
  type        = string
}
