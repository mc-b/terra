## Übung 05-5: Terraform - Multi-Cloud

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

### Übung

![](https://github.com/mc-b/duk/raw/e85d53e7765f16833ccfc24672ae044c90cd26c1/data/jupyter/demo/images/Microservices-REST.png)

Quelle: Buch Microservices Rezepte
- - -

In der heutigen digitalen Landschaft stehen Unternehmen vor der Herausforderung, ihre IT-Infrastruktur flexibel, zuverlässig und kosteneffizient zu gestalten. 

In diesem Kontext gewinnt die Multi-Cloud-Strategie zunehmend an Bedeutung. Multi-Cloud bezieht sich auf die Nutzung von mehreren Cloud-Service-Providern zur Erfüllung unterschiedlicher Anforderungen an Rechenleistung, Speicherplatz, Datenbanken und mehr.   

Basierend auf dem WebShop aus den Beispielen [03-3 Azure](../03-3-Azure), [03-6 AWS](../03-6-aws) und [03-9 GCP](../03-9-gcp) bauen wir den WebShop redudant auf allen drei Cloud Plattformen. Aus Übersichtgründen verzichten wir auf den globalen Loadbalancer. Dieser könnten wir z.B. "On Premise" betreiben.

Erstellt eine `main.tf` Datei mit folgendem Inhalt:

    # Webshop in Azure
    
    module "azure" {
      source = "../03-3-azure"
    }
    
    # Webshop in AWS
    
    module "aws" {
      source = "../03-6-aws"
    }
    
    # Webshop in Google Cloud
    
    module "gcp" {
      source = "../03-9-gcp"
    }

Meldet Euch auf allen drei Cloud Plattformen an:

    az login
    aws configure
    gcloud auth application-default login
    
Führt, wie gewohnt, die entsprechenden Terraform Befehle aus:

    terraform init
    
    terraform plan
    
    terraform apply -auto-approve
    
    
    
    


