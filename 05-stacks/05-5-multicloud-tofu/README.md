## Übung 05-5: Terraform - Multi-Cloud

Für die Übungen wird [VSCode](https://code.visualstudio.com/) und [opentofu](https://opentofu.org/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

### Übung

Als Softwarehaus betreuen wir eine Vielzahl unterschiedlicher Mandanten, die jeweils selbst bestimmen möchten, in welcher Cloud ihre Zielumgebung betrieben wird.
Daher haben wir für die drei grossen Cloud-Plattformen – Azure, AWS und GCP – eigene Terraform-Implementierungen erstellt, die über **`tofu workspace`** gezielt angesteuert werden können.

Dazu verwenden wir das Beispiel 03-3-web um dieses mandantenspezifisch auf einer der drei grossen Cloud-Plattformen aufbauen.

**Erstellen der Workspaces**

    tofu workspace new azure   # Deployment in Azure
    tofu workspace new aws     # Deployment in AWS
    tofu workspace new gcp     # Deployment in Google Cloud

**Umsetzung**

Erstellt eine `main.tf`-Datei mit folgendem Inhalt:

    locals {
      workspace    = terraform.workspace
      source_path  = (
        local.workspace == "azure" ? "../../03-azure/03-3-web/" :
        local.workspace == "aws"   ? "../../03-aws/03-3-web"   :
        local.workspace == "gcp"   ? "../../03-gcp/03-3-web"   :
        "../../03-aws/03-3-web" # Standard: AWS
      )
    }
    
    module "web" {
      subscription_id = var.subscription_id
      name_prefix = var.name_prefix
      common_tags = var.common_tags    
      source = local.source_path
    }

Ergänzt `../../03-aws/03-3-web/variables.tf` um die Variable 
    
    variable "subscription_id" {
      type = string
    }

**Anmeldung und Deployment**

Meldet euch **nur bei der Cloud-Plattform an**, die dem aktuell aktiven Workspace entspricht.

**Azure**

    tofu workspace select azure
    
    tofu init
    tofu plan
    tofu apply -auto-approve

**AWS**

    tofu workspace select aws
    
    tofu init
    tofu plan
    tofu apply -auto-approve

**Google Cloud**

    tofu workspace select gcp
    
    tofu init
    tofu plan
    tofu apply -auto-approve

OpenTofu erkennt anhand des aktiven Workspaces automatisch, welche Cloud-Konfiguration verwendet werden soll, und stellt Web dort bereit.

### 💡 Hinweis zu Terraform vs. OpenTofu

> **OpenTofu** erlaubt die dynamische Verwendung von Ausdrücken wie `${local.workspace}` (terraform: `${terraform.workspace}`) im `source`-Parameter eines Moduls.
> **Terraform** hingegen verlangt, dass `source` ein **statischer String** ist, der **nicht** von Variablen oder Workspaces abhängt.
>
> Das oben gezeigte Beispiel funktioniert daher **vollständig nur mit OpenTofu**.
> Wenn du Terraform verwendest, musst du pro Cloud-Umgebung ein eigenes Modulverzeichnis oder Wrapper-Setup (z. B. mit [Terragrunt](https://terragrunt.gruntwork.io)) verwenden.
    
    
    
    


