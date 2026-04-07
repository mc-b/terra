## Übung 03-5: Azure – Einfaches FaaS mit Azure Functions

### Übung

Dieses Beispiel zeigt eine minimal lauffähige serverlose Funktion auf Azure mit Terraform/OpenTofu. Der Fokus liegt ebenfalls auf einem möglichst einfachen HTTP-Endpunkt ohne zusätzliche Infrastruktur.

* Verständnis für serverlose Architektur (FaaS)
* Umgang mit Ressourcen pro Benutzer (Prefix, Resource Group)
* Minimaler HTTP-Endpunkt ohne VM oder Container

### Architektur

* **Azure Function App**: führt den Python-Code aus
* **Storage Account**: wird intern für die Function benötigt (Pflichtbestandteil)
* **Service Plan (Consumption)**: serverloses Abrechnungsmodell
* **HTTP Trigger**: stellt den öffentlichen HTTP-Endpunkt bereit

Der Aufruf erfolgt über eine URL wie:

    https://<function-app-name>.azurewebsites.net/api/HttpExample

### Deployment

Starten mittels

    terraform init
    terraform apply -auto-approve

Testen

    curl "$(terraform output -raw function_url)"

### Wichtige Punkte

* Azure benötigt zwingend einen Storage Account für Functions (auch ohne Nutzdaten)
* Der Consumption Plan (SKU `Y1`) ist serverlos und verursacht praktisch keine Kosten ohne Aufrufe
* Die Function wird hier direkt per ZIP deployt (kein separates Deployment-Tool notwendig)
* Der HTTP-Trigger ist hier auf `anonymous` gesetzt, damit kein zusätzlicher Key benötigt wird
* Azure Functions sind zustandslos – jeder Aufruf ist unabhängig

### Unterschiede zu AWS (konzeptionell)

* Kein separates API Gateway nötig – HTTP Trigger ist direkt Teil der Function
* Keine explizite IAM Role für Logs erforderlich – Logging ist standardmässig integriert
* Storage Account ist obligatorisch, auch für einfache Functions

