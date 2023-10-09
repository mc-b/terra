## Übung 2: Terraform

Die Übungen finden in der [Git/Bash](https://git-scm.com/downloads) statt. 

Öffnet die Git/Bash Umgebung oder VSCode und dort ein Terminal. Wechselt ins Arbeitsverzeichnis der Übung:

    cd 02-2-terraform
    
Erstellt eine Datei `main.tf` mit folgendem Inhalt

    resource "random_string" "zufallstext" {
      length  = 16
      special = false
    }
    
Führt die Terraform Befehle zum Initialisieren, Vorschau und Erstellen der Ressource aus.

    terraform init
    
    terraform plan
    
    terraform apply
    
Zerstört die Ressource wieder:

    terraform destroy
    
**Hinweis** mittels `-auto-approve` hinter `apply` und `destroy` wird die Sicherheitsabfrage übersprungen.    

###Tipps & Tricks

Um den Code (`main.tf`) sauber zu formatieren, verwendet man:

    terraform fmt

Den Code (`main.tf`) validieren:

    terraform validate
    
    