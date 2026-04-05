# Haupt-S3-Bucket-Ressource
resource "aws_s3_bucket" "terraform_state" {
  bucket = "mein-terraform-state-bucket"

  #lifecycle {
  #  prevent_destroy = true
  #}
}

# Neu: Konfiguration der "Bucket Ownership" (Besitz des Buckets)
resource "aws_s3_bucket_ownership_controls" "terraform_state_ownership" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Neu: Separates Resource für die Versionierung
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Neu: Separates Resource für das Lebenszyklus-Management (optional)
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state_lifecycle" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# Neu: Separates Resource für die Server-Side-Verschlüsselung
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Neu: Separates Resource für den Schutz des öffentlichen Zugriffs
resource "aws_s3_bucket_public_access_block" "terraform_state_public_access_block" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
