## Übung 02-5: Terraform - Data Source

Die Übungen finden in der [Git/Bash](https://git-scm.com/downloads) statt. 

Öffnet die Git/Bash Umgebung oder VSCode und dort ein Terminal. Wechselt ins Arbeitsverzeichnis der Übung:

    cd 02-5-terraform
    
Um die Firewall automatisch so Einzustellen, dass unsere eigene IP-Adresse immer Zugriff auf die erstellten Ressourcen hat, brauchen wir unsere öffentliche IP-Adresse.

Diese kann mittels einer `Data Source` ermittelt werden.

Erstellt dazu eine Datei `main.tf` mit folgendem Inhalt:

    data "http" "myip" {
      url = "http://ipv4.icanhazip.com"
    }

Führt die Standard Terraform zur Erstellung der Ressource, hier `Data Source`, aus:

    terraform init
    terraform apply -auto-approve

Zeigt die `Data Source` an

    terraform show
    
**Schritt 2 - Anzeigen der IP-Adresse**    
    
Um die nur die IP-Adresse anzuzeigen, erstellt eine Datei `outputs.tf` mit folgendem Inhalt:

    output "myip" {
      value       = data.http.myip.response_body
      description = "Meine IP Adresse"
    } 
    
`terraform apply` führt die Änderungen nach und zeigt die öffentliche IP-Adresse an.

     