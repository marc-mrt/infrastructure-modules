module "website" {
  source = "../../"

  project     = "static_website"
  environment = "example"
  owner       = "GitHub"

  domain_name = "static-website.example.com"

  aws_region = "eu-central-1"
}

resource "aws_s3_object" "index" {
  bucket       = module.website.bucket_id
  key          = "index.html"
  content_type = "text/html"
  acl          = "public-read"

  source = "assets/index.html"
  etag   = filemd5("assets/index.html")
}

resource "aws_s3_object" "styles" {
  bucket       = module.website.bucket_id
  key          = "styles.css"
  content_type = "text/css"
  acl          = "public-read"

  source = "assets/styles.css"
  etag   = filemd5("assets/styles.css")
}
