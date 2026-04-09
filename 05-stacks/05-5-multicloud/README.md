## Übung 05-5: Terraform - Multi-Cloud

In der heutigen digitalen Landschaft stehen Unternehmen vor der Herausforderung, ihre IT-Infrastruktur flexibel, zuverlässig und kosteneffizient zu gestalten. 

In diesem Kontext gewinnt die Multi-Cloud-Strategie zunehmend an Bedeutung. Multi-Cloud bezieht sich auf die Nutzung von mehreren Cloud-Service-Providern zur Erfüllung unterschiedlicher Anforderungen an Rechenleistung, Speicherplatz, Datenbanken und mehr.   

Dazu verwenden wir das Beispiel 03-3-web neu.

Erstellt eine `main.tf` Datei mit folgendem Inhalt:

    # Web in Azure
    
    module "azure" {
      subscription_id = var.subscription_id
      name_prefix = var.name_prefix
      common_tags = var.common_tags
      source = "../../03-azure/03-3-web"
    }
    
    # Web in AWS
    
    module "aws" {
      name_prefix = var.name_prefix
      common_tags = var.common_tags
      source = "../../03-aws/03-3-web"
    }

   
Führt, wie gewohnt, die entsprechenden Terraform Befehle aus:

    terraform init
    
    terraform plan
    
    terraform apply -auto-approve
    
**Hinweis**: die Web Umgebungen wurden so erstellt, dass sie die gleichen Variablen verwenden.    


