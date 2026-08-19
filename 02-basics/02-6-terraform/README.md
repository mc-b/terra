## Übung 02-6: Terraform - Provisioners 

Für die Übungen wird [VSCode](https://code.visualstudio.com/) benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, und zwar in dem Verzeichnis, in dem sich auch die Übungsdateien befinden.

### Übung
    
Kopiert die Dateien `main.tf` und `output.tf` aus der Übung [02-5-terraform](../02-5-terraform/).    
    
Mittels eines Provisioners soll die IP-Adresse ausgegeben werden. Dazu müssen wir eine zusätzliche Ressource erstellen und die `Data Source` referenzieren. 

Die Referenz erfolgt mittels `data.<source>.<data...>`.

Erweitert die `main.tf` um folgenden Code:

    resource "terraform_data" "myip" {
      # terraform apply
      provisioner "local-exec" {
        command = "echo Meine IP-Adresse ist: \${data.http.myip.response_body}"
      }
    }

Soll auch `destroy` abgehandelt werden, braucht es ein `input`-Argument. Die Data Source `data.http.myip.response_body` steht bei einem `terraform destroy` nämlich nicht mehr zur Verfügung. Über `input` speichert Terraform den Wert im State und stellt ihn beim Löschen via `self.output` bereit.

    resource "terraform_data" "myip" {
      input = data.http.myip.response_body
    
      # terraform apply
      provisioner "local-exec" {
        command = "echo Meine IP-Adresse ist: \${data.http.myip.response_body}"
      }
    
      # terraform destroy
      provisioner "local-exec" {
        when    = destroy
        command = "echo Meine IP-Adresse war: \${self.output}"
      }      
    }

Teilt die Änderungen Terraform mit und erstellt die Ressource mit den Provisioners:

    terraform init
    terraform apply -auto-approve
