## Übung 03-3-blue-green: Create an Azure Traffic Manager profile using Terraform

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) installiert sein.

### Einleitung

Übungsdateien mit dem Traffic Manager vom Azure, basierend auf dem Beispiel [Create an Azure Traffic Manager profile using Terraform](https://learn.microsoft.com/en-us/azure/traffic-manager/quickstart-create-traffic-manager-profile-terraform)

### Übung

#### Blue/Green Umgebung erstellen

Legt je ein `blue` und ein `green` Verzeichnis an.

Kopiert die *.tf Dateien von [../03-3-azure](../03-3-azure) und das das [../script](../script) Verzeichnis nach `blue` und `green`.

Führt folgende Änderungen durch

**variables.tf**

Ändert die Template Pfade von `${path.module}/../scripts/` nach `${path.module}/scripts/`

**main.tf**

Den Eintrag `name = "webshop"` der Resource `azurerm_resource_group` auf `name = "webshop-blue"` und `name = "webshop-green"` 

**Dateien im Verzeichnis** `scripts`

    write_files:
     - content: |
        <html>
         <body>
          <h1>Catalog App</h1>
         </body>
        </html>
       path: /var/www/html/index.html
       permissions: '0644'   
 
Ergänzt den Text `<h1>Catalog App</h1>` mit `<h1>Catalog App blue</h1>` und  `<h1>Catalog App green</h1>`

Erstellt im `blue` und `green` Verzeichnis je eine Umgebung.

    az login
    
    cd blue
    terraform init
    terraform apply -auto-approve
    
    cd ../green
    terraform init
    terraform apply -auto-approve    
    
Die IP-Adresse von der Ausgabe `webshop_public_ip = "<IP-Adresse>"` ist in die Datei `main.tf` in `target` zu übertragen.

**Die Einträge sehen wie folgt aus**:  

    resource "azurerm_traffic_manager_external_endpoint" "blue" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "blue"
      target            = "<1. IP-Adresse>"
      endpoint_location = "eastus"
      weight            = 500
    }
    
    resource "azurerm_traffic_manager_external_endpoint" "green" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "green"
      target            = "<2. IP-Adresse>"
      endpoint_location = "eastus"
      weight            = 500
    }

**Tipp**: die Einträge `azurerm_network_interface` und `azurerm_linux_virtual_machine` für `customer`, `catalog` und `order` werden nicht expliziet benötigt und können gelöscht werden.   

#### Traffic Manager 

Bevor wir zu Blue/Green und Canary kommen, erstellen wir zuerst einen Traffic Manager welche beide Infrastrukturen `blue` und `green` anspricht. Damit können wir die Funktionalität vom Traffic Manager und der zwei Umgebungen testen.

    cd ..                               # ins Verzeichnis 03-3-azure-blue-green
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

   