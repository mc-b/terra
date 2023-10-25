## Übung 02-3: Terraform - State

Die Übungen finden in der [Git/Bash](https://git-scm.com/downloads) statt. 

Öffnet die Git/Bash Umgebung oder VSCode und dort ein Terminal. Wechselt ins Arbeitsverzeichnis der Übung:

    cd 02-3-terraform
    
Erstellt eine Datei `main.tf` mit folgendem Inhalt

    resource "random_string" "zufallstext-1" {
      length  = 16
      special = false
    }
    
    resource "random_string" "zufallstext-2" {
      length  = 16
      special = false
    }    
    
Führt die Terraform Befehle zum Initialisieren und Erstellen der Ressource aus.

    terraform init
    
    terraform apply
    
Fragt den `State` der Ressourcen ab

    terraform state list
    
Und die Details (Metadaten)

    terraform show
    
Löscht, manuell den `State` einer Ressource und führt die Vorschau und Erstellung aus:

    terraform state rm random_string.zufallstext-1

    terraform plan
    
    terraform apply -auto-approve        
    
Ändert den Eintrag `length` einer Ressource auf 20 und führt wieder die Vorschau und Erstellung aus.

    terraform plan
    
    terraform apply -auto-approve     
    
**Wo sind die Unterschiede?**

## Optionale Übung:

Führt die Befehle ab `terraform state list` mit der [Übung 1 - Terraform mit Multipass](../02-1-terraform/) aus.

        