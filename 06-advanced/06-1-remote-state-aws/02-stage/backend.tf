
terraform {
  backend "s3" {
    bucket  = "mein-terraform-state-bucket"  # Name des S3-Buckets
    key     = "terraform/state/main.tfstate" # Pfad/Name der State-Datei im Bucket
    region  = "us-east-1"                    # Region, in der der S3-Bucket erstellt wurde
    encrypt = true                           # Verschlüsselung des State aktivieren
  }
}

