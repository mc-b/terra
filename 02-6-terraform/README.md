## Übung 6: Terraform - Provisioners 

Die Übungen finden in der [Git/Bash](https://git-scm.com/downloads) statt. 

Öffnet die Git/Bash Umgebung oder VSCode und dort ein Terminal. Wechselt ins Arbeitsverzeichnis der Übung:

    cd 02-6-terraform
    
Kopiert die Dateien `main.tf` und `output.tf` von der Übung [02-5-terraform](../02-5-terraform/)    
    
Mittels eines Provisioners soll die IP-Adresse ausgegeben werden. Dazu müssen wir eine zusätzlich eine Ressource erstellen und die `Data Source` referenzieren. 

Die Referenz erfolgt mittels `data.<source>.<data...>`.

Erweitert `main.tf` um folgenden Code:

    resource "null_resource" "myip" {
    
      triggers = {
        name = data.http.myip.response_body
      }
      # terraform apply
      provisioner "local-exec" {
        command = "echo Meine IP-Adresse ist: ${data.http.myip.response_body}"
      }
    }

Teilt die Änderungen Terraform mit und erstellt die Ressource mit den Provisioners:

    terraform init
    terraform apply -auto-approve     
     