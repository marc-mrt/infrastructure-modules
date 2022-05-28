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
resource "aws_s3_bucket_logging" "bucket" {
  count = var.with_logs ? 1 : 0

  bucket = aws_s3_bucket.bucket.id

  target_bucket = var.logs_bucket_id
  target_prefix = "bucket-${var.bucket_name}/"
}
