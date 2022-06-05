output "hello" {
  value = "Website served at ${module.website.cloudfront_domain_name}"
}
