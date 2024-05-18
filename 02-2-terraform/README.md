## Übung 02-2: Terraform - Ressource(n)

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

### Übung
    
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
   

### Tipps & Tricks

Mittels `-auto-approve` hinter `apply` und `destroy` wird die Sicherheitsabfrage übersprungen, Bsp:

    terraform apply -auto-approve

Um den Code (`main.tf`) sauber zu formatieren, verwendet man:

    terraform fmt

Den Code (`main.tf`) validieren:

    terraform validate
    
    