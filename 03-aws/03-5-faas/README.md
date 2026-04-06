## Übung 03-5: AWS - Einfaches FAAS mit AWS Lambda

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

---

## Übung: Terraform Actions verwenden (nur terraform)

Terraform Actions sind ein Mechanismus, um gezielte Operationen auf bestehender Infrastruktur auszuführen, ohne den deklarativen Zustand zu verändern.

Im Unterschied zu klassischen Terraform-Ressourcen gilt:
* Ressourcen beschreiben gewünschten Zustand (z. B. „Lambda existiert“)
* Actions führen imperative Operationen aus (z. B. „Lambda jetzt ausführen“)

Eine Action ist somit vergleichbar mit einem gezielten API-Aufruf innerhalb von Terraform selbst.

**Ziel**

* Verständnis für Terraform Actions
* Direkter Funktionsaufruf ohne API Gateway
* Analyse der Logs in CloudWatch

**Schritt 1: Datei erstellen**

Erstelle eine neue Datei `actions.tf` mit folgendem Inhalt:

    action "aws_lambda_invoke" "test" {
      config {
        function_name = aws_lambda_function.hello.function_name
    
        payload = jsonencode({
          message = "dummy"
        })
      }
    }

**Schritt 2: Action ausführen**

Führe die Action gezielt aus:

    terraform apply -invoke=action.aws_lambda_invoke.test -auto-approve

Dabei wird **nur die Action ausgeführt**, ohne dass Infrastruktur verändert wird.

**Schritt 3: Logs überprüfen**

Die Ausgabe der Lambda-Funktion kann über CloudWatch Logs eingesehen werden:

    aws logs tail "/aws/lambda/$(terraform output -raw function_name)" --since 10m

**Erwartetes Ergebnis**

* Die Lambda-Funktion wird direkt ausgeführt
* Der Payload (`message = "dummy"`) wird verarbeitet
* Ein Log-Eintrag erscheint in CloudWatch

**Hinweis**

Terraform Actions ersetzen klassische Workflows mit externen CLI-Aufrufen (z. B. `aws lambda invoke`) und ermöglichen Tests direkt innerhalb von Terraform/OpenTofu.
