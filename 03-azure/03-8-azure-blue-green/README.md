## Übung 03-3-blue-green: Create an Azure Traffic Manager profile using Terraform

Übungsdateien mit dem Traffic Manager vom Azure, basierend auf dem Beispiel [Create an Azure Traffic Manager profile using Terraform](https://learn.microsoft.com/en-us/azure/traffic-manager/quickstart-create-traffic-manager-profile-terraform)

### Übung

#### Blue/Green Umgebung erstellen

Führt die Übung [03-3 Statische Website](../03-3-web/README.md) nochmals aus, dass ist die Green Version.

Kopiert aus dem Verzeichnis 03-3-web die Dateien `main.tf` und `web.tf` in das Verzeichnis blue.

Ändert `green` auf `blue` und entfernt in `web.tf` das Verzeichnis `../03-1-cli/` vom Dateinamen.

Erstellt die Ressourcen im `blue` Verzeichnis und anschliessend in diesem Verzeichnis.

#### Traffic Manager 

Bevor wir zu Blue/Green und Canary kommen, erstellen wir zuerst einen Traffic Manager welche beide Infrastrukturen `blue` und `green` anspricht. Damit können wir die Funktionalität vom Traffic Manager und der zwei Umgebungen testen.

    cd ..                               # ins Verzeichnis 03-8-azure-blue-green
    terraform init
    terraform apply -auto-approve    
    
`target` bestimmt den Zielserver und `weight` die Verteilung der Anfragen in Promil. Probieren mit dem Edge Browser, der Chrome cacht zuviel. Alternativ `curl` verwenden.    
   
Durch ändern der Einträge in `main.tf` und ausführen von `terraform plan` und `terraform apply -auto-approve` können die EndPoints und die Verteilung `weight` angepasst werden. Dabei wird kein neuer Traffic Manager erzeugt, sondern dessen Werte geändert.

#### Blue / Green Deployment

Unter Blue / Green Deployment wird der Prozess verstanden, bei dem neben einer bisherigen Infrastruktur (Blue Deployment) parallel eine neue Version (Green Deployment) aufgebaut wird. 
Im Beispiel mit einer Gruppe von Webservern ist ein vor den Servern konfigurierter Loadbalancer der Verteiler für die Webserveranfragen. 

Er leitet die Anfragen auf das `blue` oder `green` Deployment um.

Für **blue** sehen die Einträge wie folgt aus:

    resource "azurerm_traffic_manager_external_endpoint" "blue" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "blue"
      target            = "<1. IP-Adresse>"
      endpoint_location = "eastus"
      weight            = 999
    }
    
    resource "azurerm_traffic_manager_external_endpoint" "green" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "green"
      target            = "<2. IP-Adresse>"
      endpoint_location = "eastus"
      weight            = 1
    }

Und für **green** wie folgt:

    resource "azurerm_traffic_manager_external_endpoint" "blue" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "blue"
      target            = "<1. IP-Adresse>"
      endpoint_location = "eastus"
      weight            = 1
    }
    
    resource "azurerm_traffic_manager_external_endpoint" "green" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "green"
      target            = "<2. IP-Adresse>"
      endpoint_location = "eastus"
      weight            = 999
    }

#### Canary Deployment

Ein Canary Deployment baut auf dem soeben beschriebenen reinen Blue / Green Deployment auf, unterscheidet sich jedoch von diesem.
Der Unterschied ist, dass nicht auf einmal von alt (blau) nach neu (grün) umgeschaltet wird, sondern beide Versionen in einem Verhältnis (z.B. 90/10%) aktiv sind.

Für **Canary Deployment** sehen die Einträge wie folgt aus:

    resource "azurerm_traffic_manager_external_endpoint" "blue" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "blue"
      target            = "<1. IP-Adresse>"
      endpoint_location = "eastus"
      weight            = 900
    }
    
    resource "azurerm_traffic_manager_external_endpoint" "green" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "green"
      target            = "<2. IP-Adresse>"
      endpoint_location = "eastus"
      weight            = 100
    }

   