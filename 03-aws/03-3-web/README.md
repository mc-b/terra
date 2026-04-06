## Übung 03-3: AWS - Statische Website mit S3

### Übung

Dieses Beispiel zeigt eine einfache statische Website auf AWS mit Terraform/OpenTofu. Die Website wird direkt aus einem S3-Bucket ausgeliefert. Es werden keine VMs, Container oder serverlosen Funktionen benötigt.

* Verständnis für statische Websites auf S3
* Umgang mit öffentlich lesbaren Objekten
* Minimaler Webauftritt ohne zusätzliche Infrastruktur

### Architektur

* **S3 Bucket**: speichert die Website-Dateien
* **Website Configuration**: definiert Start- und Fehlerseite
* **Bucket Policy**: erlaubt den öffentlichen Lesezugriff auf die Dateien
* **Public Access Block**: wird so gesetzt, dass die Website öffentlich erreichbar ist

Die Website ist anschliessend über eine URL wie diese erreichbar:

    http://<bucket-name>.s3-website-<region>.amazonaws.com

### Enthaltene Dateien

In diesem Beispiel werden zwei HTML-Dateien direkt durch Terraform erstellt:

* **index.html**: die eigentliche Startseite
* **error.html**: die Fehlerseite

Die Startseite enthält einen einfachen Text mit dem gesetzten Prefix:

    Hello from <name_prefix>

### Deployment

Starten mittels

    terraform init
    terraform apply -auto-approve

Die Website-URL kann danach über einen Output oder direkt im AWS S3 Website Endpoint aufgerufen werden.

### Testen

Nach dem Deployment kann die Website im Browser geöffnet werden.

Falls ein Output für den Endpoint vorhanden ist, kann auch mit `curl` getestet werden:

    curl "$(terraform output -raw website_url)"

### Wichtige Punkte

* S3 Website Hosting funktioniert nur, wenn der Bucket und seine Objekte öffentlich lesbar sind
* Dafür muss der Public Access Block bewusst entsprechend gesetzt werden
* Die Bucket Policy erlaubt `s3:GetObject` auf alle Dateien im Bucket
* Es handelt sich um eine rein statische Website ohne Backend-Logik
* Änderungen an `index.html` oder `error.html` werden beim nächsten `apply` direkt in S3 aktualisiert

### Verhalten der Ressourcen

Der Bucket wird für die Website erstellt und mit Tags versehen. Danach wird die Website-Konfiguration aktiviert:

* `index.html` als Startseite
* `error.html` als Fehlerseite

Zusätzlich werden die beiden HTML-Dateien direkt in den Bucket hochgeladen. Dadurch ist das Beispiel vollständig und sofort lauffähig.

