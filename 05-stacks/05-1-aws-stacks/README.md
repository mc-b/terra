##  Übung 05-1 AWS Stack

Wir trennen das 03-3-web Beispiel in verschiedene Stages auf und trennen damit Infrastrukturverwaltung von Applikationslogik.

### Übung

Kopiert die `main.tf` von der Übung `03-3-web` in das Verzeichnis `01-infra`.

Verschiebt die `resource "aws_s3_object" "index" {` und `resource "aws_s3_object" "error" {` Einträge in eine neue Datei `02-files/main.tf`.

Erweitert `02-files/variables.tf` um `bucket_name` als Input

    variable "bucket_name" {
      type = string
    }

Ändert `02-files/main.tf` damit neu die Variable `bucket_name` verwendet wird

    resource "aws_s3_object" "index" {
      bucket       = var.bucket_name
    ..
    
    resource "aws_s3_object" "error" {
      bucket       = var.bucket_name    

Erstellt eine Datei `components.tfcomponent.hcl` mit folgendem Inhalt

    component "infra" {
      source = "./01-infra"
    
      providers = {
        aws = provider.aws.default
      }
    
      inputs = {
        name_prefix = var.name_prefix    
        common_tags = var.common_tags
      }
    }
    
    component "files" {
      source = "./02-files"
    
      providers = {
        aws = provider.aws.default
      }
    
      depends_on = [component.infra]
    
      inputs = {
        bucket_name = component.infra.bucket_name
        name_prefix = var.name_prefix
        common_tags = var.common_tags    
      }
    }
    
Und die Deployment Datei `deployments.tfdeploy.hcl`

    deployment "dev" {
      inputs = {
        # aws_region  = "us-east-1"
        name_prefix = "${var.name_prefix}-dev"
        common_tags = merge(
          var.common_tags,
          {
            Environment = "dev"
            Project     = "web"
          }
        )
      }
    }
    
    deployment "test" {
      inputs = {
        # aws_region  = "us-east-1"
        name_prefix = "${var.name_prefix}-test"
        
        common_tags = merge(
          var.common_tags,
          {
            Environment = "test"
            Project     = "web"
          }
        )
      }
    }
    
    deployment "prod" {
      inputs = {
        # aws_region  = "eu-central-1"
        name_prefix = "${var.name_prefix}-prod"
        
        common_tags = merge(
          var.common_tags,    
          {
            Environment = "prod"
            Project     = "web"
          }
        )
      }
    }


### Deployment

Konfiguration prüfen

    terraform stacks init
    terraform stacks validate
    
Erstellen (auf HashiCorp Plattform)

    terraform stacks create \
      -organization-name "lerncloud" \
      -project-name "web" \
      -stack-name "dev"

Upload

    terraform stacks configuration upload -organization-name "lerncloud" -project-name "web" -stack-name "dev"

### Links

* [Terraform Stacks](https://developer.hashicorp.com/terraform/language/stacks)
    
    