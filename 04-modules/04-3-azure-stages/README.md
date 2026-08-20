##  Übung 04-3 Azure Stages

Wir trennen das 03-3-web Beispiel in verschiedene Stages auf und trennen damit Infrastrukturverwaltung von Applikationslogik.

### Übung

Kopiert alle  `*.tf` Dateien von der Übung `03-3-web` in das Verzeichnis `01-infra`.

Verschiebt die Datei `web.tf` nach `02-files/main.tf`. Kopiert `provider.tf` und `variables.tf` nach `02-files/main.tf`
    
Die brauchen wir als Input für `02-files`.

Ersetzt den Inhalt von `02-files/main.tf` um das lesen des `01-infra` Outputs

    data "terraform_remote_state" "infra" {
      backend = "local"
    
      config = {
        path = "../01-infra/terraform.tfstate"
      }
    }
    
    resource "azurerm_storage_blob" "website_files" {
      for_each = {
        "index.html" = "../../../03-azure/03-1-cli/site/index.html"
        "error.html" = "../../../03-azure/03-1-cli/site/error.html"
      }
    
      name                   = each.key
      storage_account_name   = data.terraform_remote_state.infra.outputs.storage_account_name
      storage_container_name = "$web"
      type                   = "Block"
      source                 = each.value
      content_type           = "text/html"
    }

Führt die Terraform Befehle zum Initialisieren, Vorschau und Erstellen der Ressourcen aus.

    cd 01-infra
    terraform init
    terraform apply 
    
    cd ../02-files
    terraform init
    terraform apply     