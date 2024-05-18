## Übung 03-9: Google Cloud und Terraform 

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss Google Cloud so konfiguriert werden, dass wir das Google Cloud SDK verwenden können.

Die Anleitung finden wir [hier](https://cloud.google.com/sdk/docs/install).

### Beispielapplikation WebShop

![](https://github.com/mc-b/duk/raw/e85d53e7765f16833ccfc24672ae044c90cd26c1/data/jupyter/demo/images/Microservices-REST.png)

Quelle: Buch Microservices Rezepte
- - -

Das Beispiel besteht aus drei Microservices: Order, Customer und Catalog.

Order nutzt Catalog und Customer mit der REST-Schnittstelle. Ausserdem bietet jeder Microservice einige HTML-Seiten an.

Zusätzlich ist im Beispiel ein Apache-Webserver installiert, der dem Benutzer mit einer Webseite einen einfachen Einstieg in das System ermöglicht.

### Übung

Implementiert den Webshop in der Google Cloud mittels Terraform.

Wechsel in das Arbeitsverzeichnis

    cd 03-9-gcp

Einloggen in GCP Cloud

    gcloud auth application-default login
    
Auflisten der aktuellen Projekte (es muss eines ausgewählt werden), übertragen in `provider.tf` und setzen via `gcloud`.
   
    gcloud projects list
    gcloud config set project <your-project-id>
    gcloud auth application-default set-quota-project <your-project-id>
    
Die weitere Arbeit übernimmt Terraform:   

    terraform init
    terraform apply -auto-approve

Nach dem erstellen der Ressourcen, VM `webshop` anwählen und IP-Adresse im Browser eingeben.

**Links**

* [Terraform Google Cloud Tutorial](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build)
* [Virtuelle Maschinen erstellen](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance)