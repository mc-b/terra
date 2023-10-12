## Übung 2: Azure und Terraform

Für die Übung sind die CLI für Azure und Terraform zu installieren.

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
* [Terraform Installation](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)

### Beispielapplikation WebShop

![](https://github.com/mc-b/duk/raw/e85d53e7765f16833ccfc24672ae044c90cd26c1/data/jupyter/demo/images/Microservices-REST.png)

Quelle: Buch Microservices Rezepte
- - -

Das Beispiel besteht aus drei Microservices: Order, Customer und Catalog.

Order nutzt Catalog und Customer mit der REST-Schnittstelle. Ausserdem bietet jeder Microservice einige HTML-Seiten an.

Zusätzlich ist im Beispiel ein Apache-Webserver installiert, der dem Benutzer mit einer Webseite einen einfachen Einstieg in das System ermöglicht.


### Vorgehen

Implementiert den [Webshop](../A#beispielapplikation-webshop) in der Azure Cloud mittels Terraform.

Starten mittels

    cd 03-2-azure

    az login
    
    terraform init
    terraform apply -auto-approve

Nach dem erstellen der Ressourcen, VM `webshop` anwählen und IP-Adresse im Browser eingeben.

**Links**

* [Virtuelle Maschinen erstellen](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/virtual-machines)