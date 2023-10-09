## Übung 1: Terraform

Dazu Erstellen wir zwei VMs:
* eine VM mit dem Apache Web Server, PHP und Adminer
* eine VM mit der MySQL Datenbank

Die Übungen finden in der [Git/Bash](https://git-scm.com/downloads) statt. 

Öffnet die Git/Bash Umgebung oder VSCode und dort ein Terminal. Wechselt ins Arbeitsverzeichnis der Übung:

    cd 02-2-terraform
    
Erstellt eine Datei `main.tf` mit folgendem Inhalt

    resource "random_string" "zufallstext" {
      length  = 16
      special = false
    }     
    
Führt die Terraform Befehle zum Erstellen der Resource aus.

    terraform init
    
    terraform plan
    
    terraform apply
    
           