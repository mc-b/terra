## Übung 03-9: Google Cloud und Terraform - übersetzt von AWS mittels ChatGPT

Für die Übung sind die CLI für Google Cloud und Terraform zu installieren.

* [Google Cloud SDK Installation](https://cloud.google.com/sdk/docs/install)   
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

Als erstes muss der Eintrag:

    <PROJECT_ID>

entsprechend deiner GCP-Konfiguration angepasst werden. Dies geschieht in der Datei `main.tf`.

Dann kann das Beispiel gestartet werden:

    cd 03-9-gcp

Einloggen in GCP Cloud

    gcloud auth application-default login
    
Auflisten der aktuellen Projekte (es muss eines ausgewählt werden), übertragen in `provider.tf` setzen via `gcloud`.
   
    gcloud projects list
    gcloud config set project <your-project-id>    

    terraform init
    terraform apply -auto-approve

Nach dem erstellen der Ressourcen, VM `webshop` anwählen und IP-Adresse im Browser eingeben.

**Links**

* [Terraform Google Cloud Tutorial](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build)
* [Virtuelle Maschinen erstellen](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance)