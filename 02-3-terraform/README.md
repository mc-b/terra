## Übung 02-3: Terraform - State

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

### Übung
    
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

        