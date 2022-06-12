output "certificate_arn" {
  value       = aws_acm_certificate.main.arn
  description = "The certificate's ARN"
}
