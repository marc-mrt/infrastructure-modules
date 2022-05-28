output "arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "The bucket's ARN"
}

output "id" {
  value       = aws_s3_bucket.bucket.id
  description = "The bucket's ID"
}

output "regional_domain_name" {
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
  description = "The bucket's regional domain name"
}
