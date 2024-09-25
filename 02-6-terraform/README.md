## Übung 02-6: Terraform - Provisioners 

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

### Übung
    
Kopiert die Dateien `main.tf` und `output.tf` von der Übung [02-5-terraform](../02-5-terraform/)    
    
Mittels eines Provisioners soll die IP-Adresse ausgegeben werden. Dazu müssen wir eine zusätzlich eine Ressource erstellen und die `Data Source` referenzieren. 

Die Referenz erfolgt mittels `data.<source>.<data...>`.

Erweitert `main.tf` um folgenden Code:

    resource "null_resource" "myip" {
    
      # terraform apply
      provisioner "local-exec" {
        command = "echo Meine IP-Adresse ist: ${data.http.myip.response_body}"
      }
    }

Soll auch `destroy` abgehandelt werden, braucht es `triggers` weil `data.http.myip.response_body` bei `terraform destroy` nicht mehr zur Verfügung steht.

    resource "null_resource" "myip" {
    
      triggers = {
        name = data.http.myip.response_body
      }
      # terraform apply
      provisioner "local-exec" {
        command = "echo Meine IP-Adresse ist: ${data.http.myip.response_body}"
      }

      # terraform apply
      provisioner "local-exec" {
        when    = destroy
        command = "echo Meine IP-Adresse war: ${self.triggers.name}"
      }      
    }

Teilt die Änderungen Terraform mit und erstellt die Ressource mit den Provisioners:

    terraform init
    terraform apply -auto-approve     
     