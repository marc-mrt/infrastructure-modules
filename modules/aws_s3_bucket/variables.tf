variable "bucket_name" {
  description = "The name used to create the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Whether to empty bucket before attempting destroy"
  type        = bool
  default     = false
}

variable "with_version" {
  description = "Enables versioning presets with lifecycle rules"
  type        = bool
  default     = false
}

variable "bucket_acl" {
  description = "The bucket's ACL"
  type        = string
  default     = "private"
}

variable "with_logs" {
  description = "Whether the bucket will ouput logs, requires 'logs_bucket_id'."
  type        = bool
  default     = false
}

variable "logs_bucket_id" {
  description = "The id of the bucket used to persist logs from this bucket, required if 'with_logs=true'."
  type        = string
  default     = ""
}
