## Übung 03-8: Google Cloud - Terraform Import 

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss Google Cloud so konfiguriert werden, dass wir das Google Cloud SDK verwenden können.

Die Anleitung finden wir [hier](https://cloud.google.com/sdk/docs/install).

### Übung

In dieser Übung wollen wir die erstellten Google Ressourcen aus [Übung 7](../03-7-gcp/) nach Terraform überführen.
    
Erstellen einer Datei `provider.tf`, für den GCP Provider, mit folgenden Inhalt.    

    terraform {
      required_providers {
        google = {
          source  = "hashicorp/google"
          version = "~> 3.5"
        }
      }
    
      required_version = ">= 0.14.9"
    }
    
    provider "google" {
      project = "<your-project-id>"
      region  = "us-east1"
      zone    = "us-east1-b"
    }
    
Initialisierung des Providers

    terraform init    

Einloggen in GCP Cloud

    gcloud auth application-default login
    
Auflisten der aktuellen Projekte (es muss eines ausgewählt werden), übertragen in `provider.tf` setzen via `gcloud`.
   
    gcloud projects list
    gcloud config set project <your-project-id>

### Virtuelle Maschine

Um die Ressource Gruppe zu importieren, brauchen wir deren `id`. Deshalb zeigen wir mit dem GCP CLI zuerst deren Informationen an:

    gcloud compute instances describe myvm --zone=us-east1-b
    
Die Ausgabe sieht in etwa so aus:

    creationTimestamp: '2022-04-19T12:34:56.789-07:00'
    id: '1234567890123456789'

Import (1234567890123456789 durch ID von oben ersetzen) 

    terraform import google_compute_instance.myvm 1234567890123456789
    
Oder direkt als Bash Script

    ID=$(gcloud compute instances describe myvm --zone=us-east1-b --format="value(id)")
    terraform import google_compute_instance.myvm ${ID}
 
    
Deklaration

    terraform state show google_compute_instance.myvm        
   
        
#### Restliche Ressourcen

Für die restlichen Ressourcen wie
- Netzwerk
- Firewall
etc. bleibt das Vorgehen gleich.

Die benötigten Metadaten sind in `main.tf` zu überführen, variable Werte durch Variablen `variables.tf` ersetzen und mit den bekannten Terraform Befehlen testen.

### Variante 2 - Experimentell

Erstellt eine Datei `import.tf` und fügt alle zu Importierenden Ressourcen, im nachfolgenden Format, in die Datei ein:

    import {
        to  = google_compute_instance.main
        id  = "1234567890123456789"
    }
    
Löscht eine evtl. vorhandene `main.tf` Datei weg `rm main.tf`.    

Mittels `terraform plan` können die entsprechenden Terraform Deklaration automatisch erstellt werden:

    terraform plan -generate-config-out main.tf
 
### Links

* [Google Cloud SDK Installation](https://cloud.google.com/sdk/docs/install)         
* [Google Cloud SDK Dokumentation](https://cloud.google.com/sdk)
* [Terraform Google Cloud Tutorial](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
* [Neue Import Variante](https://www.youtube.com/watch?v=znfh_00EDZ0&ab_channel=NedintheCloud)

