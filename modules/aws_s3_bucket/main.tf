# --------------------------------------------------------------------------------------------
# ----------------------------------------- BUCKET ------------------------------------------
# --------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.bucket_versioning]

  bucket = aws_s3_bucket.bucket.bucket

  rule {
    id = "deprecate_versions"

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "ONEZONE_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 120
    }

    status = "Enabled"
  }
}

# -----------------------------------------------------------------------------------------
# ----------------------------------------- LOGS ------------------------------------------
# -----------------------------------------------------------------------------------------
resource "aws_s3_bucket" "bucket_logs" {
  bucket        = "${var.bucket_name}-logs"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "bucket_logs_acl" {
  bucket = aws_s3_bucket.bucket_logs.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  target_bucket = aws_s3_bucket.bucket_logs.id
  target_prefix = "log/"
}
