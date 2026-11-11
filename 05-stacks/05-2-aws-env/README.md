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

### Folgende Anpassungen wurden bereits vorgenommen:

`variables.tf` - die Variable environment wurde ergänzt, damit Terraform die gewünschte Umgebung auswählen kann.

    locals {
      bucket_name = "${var.name_prefix}-${data.aws_caller_identity.current.account_id}-${environment}"
      html_path   = "${path.module}/environments/${local.environment}"
    }
    
    variable "environment" {
      type = string
    }

`main.tf` - der S3-Bucket-Name wurde um die Umgebung erweitert, damit jede Umgebung einen eigenen Bucket erhält.

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
    
- Die Ressourcen aws_s3_object.index und aws_s3_object.error verwenden nun die HTML-Dateien aus diesem Pfad.    

### Übung: .tfvars-Dateien erstellen

**Entwicklungsumgebung**

Erstellt die Datei environments/dev/dev.tfvars mit folgendem Inhalt:

    environment = "dev"
    
**Testumgebung**

Erstellt die Datei environments/test/test.tfvars mit folgendem Inhalt:

    environment = "test"
    
**Produktionsumgebung**

Erstellt die Datei environments/prod/prod.tfvars mit folgendem Inhalt:

    environment = "prod"

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



