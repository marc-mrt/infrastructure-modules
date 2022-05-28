# ------------------------------------------------------------------------------------
# ----------------------------------------- S3 ---------------------------------------
# ------------------------------------------------------------------------------------
locals {
  website_bucket_name = var.domain_name
  logs_bucket_name    = "${var.domain_name}-logs"
}

module "logs_bucket" {
  source = "../aws_s3_bucket"

  with_version  = false
  force_destroy = true

  bucket_name = local.logs_bucket_name
  bucket_acl  = "log-delivery-write"
}

module "website_bucket" {
  source = "../aws_s3_bucket"

  with_version  = true
  force_destroy = false

  bucket_name = local.website_bucket_name
  bucket_acl  = "public-read"

  with_logs      = true
  logs_bucket_id = module.logs_bucket.id
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = module.website_bucket.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_policy" "read_all_objects" {
  bucket = module.website_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PolicyForWebsiteEndpointsPublicContent",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${module.website_bucket.arn}/*",
        "${module.website_bucket.arn}"
      ]
    }
  ]
}
POLICY
}

# --------------------------------------------------------------------------------------------
# ----------------------------------------- CLOUDFRONT ---------------------------------------
# --------------------------------------------------------------------------------------------
locals {
  S3_origin = "S3.${local.website_bucket_name}"
}

resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = module.website_bucket.regional_domain_name
    origin_id   = local.S3_origin

    # S3 supports HTTP only.
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.index_document

  price_class = var.distribution_priceclass

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_page_path    = var.spa_support ? "/${var.index_document}" : "/${var.notfound_document}"
    response_code         = var.spa_support ? 200 : 404
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.S3_origin
    min_ttl          = 0
    default_ttl      = 300
    max_ttl          = 1200

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  logging_config {
    include_cookies = false
    bucket          = module.logs_bucket.regional_domain_name
    prefix          = "cloudfront-${local.website_bucket_name}/"
  }
}
