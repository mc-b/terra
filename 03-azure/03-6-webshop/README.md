## Übung 03-3: Azure und Terraform

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) installiert sein.

### Beispielapplikation WebShop

![](https://github.com/mc-b/duk/raw/e85d53e7765f16833ccfc24672ae044c90cd26c1/data/jupyter/demo/images/Microservices-REST.png)

Quelle: Buch Microservices Rezepte
- - -

Das Beispiel besteht aus drei Microservices: Order, Customer und Catalog.

Order nutzt Catalog und Customer mit der REST-Schnittstelle. Ausserdem bietet jeder Microservice einige HTML-Seiten an.

Zusätzlich ist im Beispiel ein Apache-Webserver installiert, der dem Benutzer mit einer Webseite einen einfachen Einstieg in das System ermöglicht.

### Übung

Implementiert den [Webshop](../A#beispielapplikation-webshop) in der Azure Cloud mittels Terraform.

    az login
    
    terraform init
    terraform apply -auto-approve

Nach dem erstellen der Ressourcen: Ressource Gruppe `webshop` und dann VM `webshop`, im Azure Portal, anwählen und Public IP-Adresse im Browser eingeben.

**Links**

* [Virtuelle Maschinen erstellen](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/virtual-machines)