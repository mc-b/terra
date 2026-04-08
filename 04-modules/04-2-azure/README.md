## Übung 04-2: Azure - bestehende Konfiguration wiederverwenden.

Wir wollen die Konfigurationen aus 03-3-web und 03-4-db wiederverwenden.

### Übung

Erstellt eine `main.tf` mit folgenden Inhalt

    module "web" {
      source = "../../03-azure/03-3-web"
    
      subscription_id = var.subscription_id
      location = var.location
      name_prefix = var.name_prefix
      common_tags = var.common_tags
    }
    
    module "db" {
      source = "../../03-azure/03-4-db"
    
      subscription_id = var.subscription_id
      location = var.location
      name_prefix = var.name_prefix
      common_tags = var.common_tags
    }
    
Um den URL der Webseite anzuzeigen braucht es zusätzlich eine `output.tf`

    output "primary_web_endpoint" {
      description = "Primärer Endpoint der statischen Website"
      value       = module.web.primary_web_endpoint
    }
    
    output "website_url" {
      description = "URL der statischen Website"
      value       = module.web.website_url
    }   
    
Und Testen das Ganze:

Führt die Terraform Befehle zum Initialisieren, Vorschau und Erstellen der Ressource aus.

    terraform init
    terraform apply       