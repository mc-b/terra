## Übung 03-5: AWS - Einfaches FAAS mit AWS Lambda

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [AWS CLI](https://aws.amazon.com/de/cli/) installiert sein.

### Übung

Dieses Beispiel zeigt eine minimal lauffähige serverlose Funktion auf AWS mit Terraform/OpenTofu. Der Fokus liegt auf einem möglichst einfachen HTTP-Endpunkt ohne komplexe Infrastruktur.

* Verständnis für serverlose Architektur (FaaS)
* Umgang mit IAM-Einschränkungen pro Benutzer
* Minimaler HTTP-Endpunkt ohne VM oder Container

### Architektur

* **AWS Lambda**: führt den Python-Code aus
* **IAM Role**: erlaubt der Funktion Logs nach CloudWatch zu schreiben
* **API Gateway (HTTP API)**: stellt einen öffentlichen HTTP-Endpunkt bereit

Der Aufruf erfolgt über eine URL wie:

    https://<api-id>.execute-api.<region>.amazonaws.com/

### Deployment

Starten mittels

    terraform init
    terraform apply -auto-approve

Testen

    curl "$(terraform output -raw url)"

### Wichtige Punkte

* IAM-Berechtigungen sind bewusst auf diesen Prefix eingeschränkt
* API Gateway wird verwendet, um die Komplexität der Function URL Berechtigungen zu vermeiden
* Lambda selbst ist zustandslos – jeder Aufruf ist unabhängig
