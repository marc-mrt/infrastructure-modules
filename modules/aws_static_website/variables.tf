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

# -----------------------------------------------------------------------------------------------
# ---------------------------------------- CLOUDFRONT -------------------------------------------
# -----------------------------------------------------------------------------------------------
variable "distribution_priceclass" {
  description = "The priceclass for the website's cloudfront distribution"
  default     = "PriceClass_100"
  type        = string
}

# ------------------------------------------------------------------------------------------------
# ---------------------------------------- WEBSITE -------------------------------------------
# ------------------------------------------------------------------------------------------------
variable "domain_name" {
  description = "The domain name used to create the S3 bucket"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The certificate arn used for the cloudfront distribution"
  type        = string
  default     = ""
}

variable "acm_certificate" {
  description = "Whether or not an ACM certificate will be used"
  type        = bool
  default     = false
}

variable "index_document" {
  description = "The index document for the website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The error document for the website"
  type        = string
  default     = "error.html"
}

variable "notfound_document" {
  description = "The 404 document for the website"
  type        = string
  default     = "404.html"
}

variable "spa_support" {
  description = "SPA support will enable error handling to go to the index document for the app to handle by itself."
  type        = bool
  default     = false
}
