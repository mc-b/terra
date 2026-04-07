## Übung 03-8 Blue/Green

### Übung

#### Blue/Green Umgebung erstellen

Führt die Übung [03-3 Statische Website](../03-3-web/README.md) nochmals aus, dass ist die Green Version.

Kopiert aus dem Verzeichnis 03-3-web die Dateien `main.tf` und `web.tf` in das Verzeichnis blue.

Ändert `green` auf `blue` und entfernt in `web.tf` das Verzeichnis `../03-1-cli/` vom Dateinamen.

Erstellt die Ressourcen im `blue` Verzeichnis und anschliessend in diesem Verzeichnis.

#### Front Door

Bevor wir zu Blue/Green und Canary kommen, erstellen wir zuerst einen Traffic Manager welche beide Infrastrukturen `blue` und `green` anspricht. Damit können wir die Funktionalität vom Front Door und der zwei Umgebungen testen.

    cd ..                               # ins Verzeichnis 03-8-azure-blue-green
    terraform init
    terraform apply -auto-approve    
    
`target` bestimmt den Zielserver und `weight` die Verteilung der Anfragen in Promil. Probieren mit dem Edge Browser, der Chrome cacht zuviel. Alternativ `curl` verwenden.    
   
Durch ändern der Einträge in `main.tf` und ausführen von `terraform plan` und `terraform apply -auto-approve` können die EndPoints und die Verteilung `weight` angepasst werden. Dabei wird kein neuer Traffic Manager erzeugt, sondern dessen Werte geändert.

**Hinweis (von Microsoft)**:

AFD configuration updates take up to 20 minutes to take effect. Back to Back changes may take up to 40 minutes. More details in Azure Front Door Frequently Asked Questions (FAQ).

#### Blue / Green Deployment

Unter Blue / Green Deployment wird der Prozess verstanden, bei dem neben einer bisherigen Infrastruktur (Blue Deployment) parallel eine neue Version (Green Deployment) aufgebaut wird. 
Im Beispiel mit einer Gruppe von Webservern ist ein vor den Servern konfigurierter Loadbalancer der Verteiler für die Webserveranfragen. 

Er leitet die Anfragen auf das `blue` oder `green` Deployment um.

Für **blue** sehen die Einträge wie folgt aus:

    resource "azurerm_cdn_frontdoor_origin" "green" {
      name                          = "green"
      ...
      weight   = 0
    }

    resource "azurerm_cdn_frontdoor_origin" "blue" {
      name                          = "blue"
      ...
      weight   = 1000
    }

Und für **green** wie folgt:


    resource "azurerm_cdn_frontdoor_origin" "green" {
      name                          = "green"
      ...
      weight   = 1000
    }

    resource "azurerm_cdn_frontdoor_origin" "blue" {
      name                          = "blue"
      ...
      weight   = 0
    }

#### Canary Deployment

Ein Canary Deployment baut auf dem soeben beschriebenen reinen Blue / Green Deployment auf, unterscheidet sich jedoch von diesem.
Der Unterschied ist, dass nicht auf einmal von alt (blau) nach neu (grün) umgeschaltet wird, sondern beide Versionen in einem Verhältnis (z.B. 90/10%) aktiv sind.

Für **Canary Deployment** sehen die Einträge wie folgt aus:

    resource "azurerm_cdn_frontdoor_origin" "green" {
      name                          = "green"
      ...
      weight   = 900
    }

    resource "azurerm_cdn_frontdoor_origin" "blue" {
      name                          = "blue"
      ...
      weight   = 100
    }

   