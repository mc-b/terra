## Übung 03-7: Google Cloud (GCP)

Als Cloud-init Datei verwenden wir die gleiche YAML-Datei wie aus [Übung 1](../01-1-iac/cloud-init-nginx.yaml).

Mittels dieser Datei und dem Google Cloud SDK, erstellen wir eine neue VM.

### Vorgehen

Zuerst muss Google Cloud so konfiguriert werden, dass wir das Google Cloud SDK verwenden können.

Die Anleitung finden wir [hier](https://cloud.google.com/sdk/docs/install).

Wechsel in das Arbeitsverzeichnis

    cd 03-7-gcp

Einloggen in Google Cloud und Umgebung Initialisieren

    gcloud auth login
    gcloud init

**Tipp** sollte eine Fehlermeldung wegen fehlenden PowerShell Rechten kommen `PowerShell.exe -ExecutionPolicy Bypass -File "C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.ps1"` statt `gcloud` verwenden.        

Anschließend müssen folgende Aktionen ausgeführt werden:
* Firewall-Regel erstellen und Ports öffnen
* Erstellen der VM 

<pre>
gcloud compute firewall-rules create myfwrule --allow tcp:22,tcp:80 --description "Standard Ports"

gcloud compute instances create myinstance --image-family ubuntu-2204-lts --image-project ubuntu-os-cloud --machine-type f1-micro --tags http-server --metadata-from-file startup-script=cloud-init.yaml
</pre>    

Anschließend können wir uns die laufenden VMs anzeigen

    gcloud compute instances list

**Überprüft das Ergebnis, indem ihr die IP-Adresse Eurer VM im Browser auswählt.**

Um die erstellten Ressourcen zu löschen, genügt es, die VM zu löschen:

    gcloud compute instances delete myinstance

### Links

* [Google Cloud SDK Installation](https://cloud.google.com/sdk/docs/install)         
* [Google Cloud SDK Dokumentation](https://cloud.google.com/sdk)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
