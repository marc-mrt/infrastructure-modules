output "bucket_arn" {
  value       = module.website_bucket.arn
  description = "The bucket's ARN"
}

output "bucket_id" {
  value       = module.website_bucket.id
  description = "The bucket's ID"
}

output "cloudfront_distribution_arn" {
  value       = aws_cloudfront_distribution.website_distribution.arn
  description = "The CloudFront distribution's ARN"
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.website_distribution.id
  description = "The CloudFront distribution's ID"
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.website_distribution.domain_name
  description = "The CloudFront distribution's domain name"
}
