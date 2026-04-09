##  Übung 05-2 AWS Environment

Für verschiedene Umgebungen wie `dev`, `test`, `prod` strukturieren wir das Beispiel 03-3-web neu.

├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
└── environments
    ├── dev
    │   ├── dev.tfvars
    │   ├── index.html
    │   └── error.html
    ├── test
    │   ├── test.tfvars
    │   ├── index.html
    │   └── error.html
    └── prod
        ├── prod.tfvars
        ├── index.html
        └── error.html
        
Die `*.html` Dateien entfernen wir aus Terraform und legen sie separat ab und arbeiten neu mit `*.tfvars` pro Umgebung.        

### Übung

Ändert/Erweitert folgende Dateien

`variables.tf` ergänzt `html_path` und Variable `environment`

    locals {
      bucket_name = "${var.name_prefix}-${data.aws_caller_identity.current.account_id}-${environment}"
      html_path   = "${path.module}/environments/${local.environment}"
    }
    
    variable "environment" {
      type = string
    }

`main.tf` ersetzt die zwei Ressourcen

    resource "aws_s3_object" "index" {
      bucket       = aws_s3_bucket.website.id
      key          = "index.html"
      source       = "${local.html_path}/index.html"
      content_type = "text/html"
      etag         = filemd5("${local.html_path}/index.html")
    }
    
    resource "aws_s3_object" "error" {
      bucket       = aws_s3_bucket.website.id
      key          = "error.html"
      source       = "${local.html_path}/error.html"
      content_type = "text/html"
      etag         = filemd5("${local.html_path}/error.html")
    }

### Deployment

Starten mittels

    terraform init
    terraform plan -var-file=environments/dev/dev.tfvars    
    
Dev Umgebung deployen    
    
    terraform apply -auto-approve -var-file=environments/dev/dev.tfvars
    
Test Umgebung deployen
    
    terraform apply -auto-approve -var-file=environments/test/test.tfvars
    
Produktions Umgebung deployen
    
    terraform apply -auto-approve -var-file=environments/prod/prod.tfvars

Die Website-URL kann danach über einen Output oder direkt im AWS S3 Website Endpoint aufgerufen werden.

**Frage**: wo sind die Probleme bei dieser Lösung?

### Aufräumen

    terraform destroy -auto-approve -var-file=environments/prod/prod.tfvars



