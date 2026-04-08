##  Übung 04-3 AWS Stages

Wir trennen das 03-3-web Beispiel in verschiedene Stages auf und trennen damit Infrastrukturverwaltung von Applikationslogik.

### Übung

Kopiert die `main.tf` von der Übung `03-3-web` in das Verzeichnis `01-infra`.

Verschiebt die `resource "aws_s3_object" "index" {` und `resource "aws_s3_object" "error" {` Einträge in eine neue Datei `02-files/main.tf`.

Kopiert die Datei `03-3-web/outputs.tf` nach `01-infra` und ergänzt folgende Einträge:

    output "bucket_id" {
      value = aws_s3_bucket.website.id
    }
    
    output "bucket_name" {
      value = aws_s3_bucket.website.bucket
    }
    
    output "bucket_arn" {
      value = aws_s3_bucket.website.arn
    }
    
Die brauchen wir als Input für `02-files`.

Ergänzt/Erweitert `02-files/main.tf` um das lesen des `01-infra` Outputs

    data "terraform_remote_state" "s3_bucket" {
      backend = "local"
    
      config = {
        path = "../01-infra/terraform.tfstate"
      }
    }
    
    resource "aws_s3_object" "index" {
      bucket       = data.terraform_remote_state.s3_bucket.outputs.bucket_name
    ...
    
    resource "aws_s3_object" "error" {
      bucket       = data.terraform_remote_state.s3_bucket.outputs.bucket_name
    ...
    
Und erstellt eine `02-files/outputs.tf`

    output "website_bucket_name" {
      value = data.terraform_remote_state.s3_bucket.outputs.website_bucket_name
    }
    
    output "website_url" {
      value = data.terraform_remote_state.s3_bucket.outputs.website_url
    }    

Führt die Terraform Befehle zum Initialisieren, Vorschau und Erstellen der Ressourcen aus.

    cd 01-infra
    terraform init
    terraform apply 
    
    cd ../02-files
    terraform init
    terraform apply     