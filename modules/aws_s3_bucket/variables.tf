variable "bucket_name" {
  description = "The name used to create the S3 bucket"
  type        = string
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
