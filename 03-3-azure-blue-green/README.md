## Übung 03-3-blue-green: Create an Azure Traffic Manager profile using Terraform

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) installiert sein.

### Einleitung

Übungsdateien mit dem Traffic Manager vom Azure, basierend auf dem Beispiel [Create an Azure Traffic Manager profile using Terraform](https://learn.microsoft.com/en-us/azure/traffic-manager/quickstart-create-traffic-manager-profile-terraform)

### Übung

Erstellt einen Traffic Manager mit 2 Endpoints in der Azure Cloud

    az login
    
    terraform init
    terraform apply -auto-approve
    
    
Durch ändern der Einträge in `main.tf` und ausführen von `terraform plan` und `terraform apply -auto-approve` können die EndPoints und die Verteilung `weight` angepasst werden. Dabei wir kein neuer Traffic Manager erzeugt, sondern dessen Werte geändert.

**Die Einträge sehen wie folgt aus**:  

    resource "azurerm_traffic_manager_external_endpoint" "endpoint1" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "endpoint1"
      target            = "www.contoso.com"
      endpoint_location = "eastus"
      weight            = 50
    }
    
    resource "azurerm_traffic_manager_external_endpoint" "endpoint2" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "endpoint2"
      target            = "www.fabrikam.com"
      endpoint_location = "westus"
      weight            = 50
    }
    
`target` bestimmt den Zielserver und `weight` die Verteilung der Anfragen in Promil. Probieren mit dem Edge Browser, der Chrome cacht zuviel.
    