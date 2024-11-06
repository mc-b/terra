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
    
    terraform init
    terraform apply -auto-approve
    
Die IP-Adresse von der Ausgabe `webshop_public_ip = "<IP-Adresse>"` ist unten in `target` zu übertragen.    

#### Traffic Manager 

Erstellt einen Traffic Manager mit 2 Endpoints in der Azure Cloud

    az login
    
    terraform init
    terraform apply -auto-approve
    
    
Durch ändern der Einträge in `main.tf` und ausführen von `terraform plan` und `terraform apply -auto-approve` können die EndPoints und die Verteilung `weight` angepasst werden. Dabei wir kein neuer Traffic Manager erzeugt, sondern dessen Werte geändert.

**Die Einträge sehen wie folgt aus**:  

    resource "azurerm_traffic_manager_external_endpoint" "endpoint1" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "endpoint1"
      target            = "<1. IP-Adresse>"
      endpoint_location = "eastus"
      weight            = 50
    }
    
    resource "azurerm_traffic_manager_external_endpoint" "endpoint2" {
      profile_id        = azurerm_traffic_manager_profile.profile.id
      name              = "endpoint2"
      target            = "<2. IP-Adresse>"
      endpoint_location = "eastus"
      weight            = 50
    }
    
`target` bestimmt den Zielserver und `weight` die Verteilung der Anfragen in Promil. Probieren mit dem Edge Browser, der Chrome cacht zuviel. Alternativ verschiedene Browser Fenster (nicht Tabs) öffnen.
    