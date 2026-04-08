## Übung 04-2: AWS - bestehende Konfiguration wiederverwenden.

Wir wollen die Konfigurationen aus 03-3-web und 03-4-db wiederverwenden.

### Übung

Erstellt eine `main.tf` mit folgenden Inhalt

    module "web" {
      source = "../../03-aws/03-3-web"
      
      name_prefix = var.name_prefix
      common_tags = var.common_tags
    }
    
    module "db" {
      source = "../../03-aws/03-4-db"
      
      name_prefix = var.name_prefix
      common_tags = var.common_tags
    }
    
Um den URL der Webseite anzuzeigen braucht es zusätzlich eine `output.tf`

    output "website_bucket_name" {
      value = module.web.website_bucket_name
    }
    
    output "website_url" {
      value = module.web.website_url
    }    
    
Und Testen das Ganze:

Führt die Terraform Befehle zum Initialisieren, Vorschau und Erstellen der Ressource aus.

    terraform init
    terraform apply       