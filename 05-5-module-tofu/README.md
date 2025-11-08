## Übung 05-5: Terraform - Multi-Cloud

Für die Übungen wird [VSCode](https://code.visualstudio.com/) und [opentofu](https://opentofu.org/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

### Übung

![](https://github.com/mc-b/duk/raw/e85d53e7765f16833ccfc24672ae044c90cd26c1/data/jupyter/demo/images/Microservices-REST.png)

Quelle: Buch Microservices Rezepte
- - -

Als Softwarehaus betreuen wir eine Vielzahl unterschiedlicher Mandanten, die jeweils selbst bestimmen möchten, in welcher Cloud ihre Zielumgebung betrieben wird.
Daher haben wir für die drei grossen Cloud-Plattformen – Azure, AWS und GCP – eigene Terraform-Implementierungen erstellt, die über **`tofu workspace`** gezielt angesteuert werden können.

Auf Grundlage der WebShop-Beispiele aus [03-3 Azure](../03-3-Azure), [03-6 AWS](../03-6-aws) und [03-9 GCP](../03-9-gcp) lässt sich der WebShop mandantenspezifisch auf einer der drei großen Cloud-Plattformen aufbauen.

**Erstellen der Workspaces**

    tofu workspace new azure   # Deployment in Azure
    tofu workspace new aws     # Deployment in AWS
    tofu workspace new gcp     # Deployment in Google Cloud

**Umsetzung**

Erstellt eine `main.tf`-Datei mit folgendem Inhalt:

    locals {
      workspace    = terraform.workspace
      source_path  = (
        local.workspace == "azure" ? "../03-3-azure" :
        local.workspace == "aws"   ? "../03-6-aws"   :
        local.workspace == "gcp"   ? "../03-9-gcp"   :
        "../03-3-azure" # Standard: Azure
      )
    }
    
    module "webshop" {
      source = local.source_path
    }

**Anmeldung und Deployment**

Meldet euch **nur bei der Cloud-Plattform an**, die dem aktuell aktiven Workspace entspricht.

**Azure**

    tofu workspace select azure
    az login
    
    tofu init
    tofu plan
    tofu apply -auto-approve

**AWS**

    tofu workspace select aws
    aws configure
    
    tofu init
    tofu plan
    tofu apply -auto-approve

**Google Cloud**

    tofu workspace select gcp
    gcloud auth application-default login
    
    tofu init
    tofu plan
    tofu apply -auto-approve

Terraform (bzw. OpenTofu) erkennt anhand des aktiven Workspaces automatisch, welche Cloud-Konfiguration verwendet werden soll, und stellt den WebShop dort bereit.

### 💡 Hinweis zu Terraform vs. OpenTofu

> **OpenTofu** erlaubt die dynamische Verwendung von Ausdrücken wie `${tofu.workspace}` im `source`-Parameter eines Moduls.
> **Terraform** hingegen verlangt, dass `source` ein **statischer String** ist, der **nicht** von Variablen oder Workspaces abhängt.
>
> Das oben gezeigte Beispiel funktioniert daher **vollständig nur mit OpenTofu**.
> Wenn du Terraform verwendest, musst du pro Cloud-Umgebung ein eigenes Modulverzeichnis oder Wrapper-Setup (z. B. mit [Terragrunt](https://terragrunt.gruntwork.io)) verwenden.
    
    
    
    


