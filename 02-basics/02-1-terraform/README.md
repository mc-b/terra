## Übung 02-1: Terraform mit Multipass

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das Produkt [Multipass](https://multipass.run/) installiert sein.

### Einleitung

Um das Zusammenspiel von Terraform und Multipass zu zeigen, erstellen wir zwei VMs:
* eine VM mit dem Apache Web Server, PHP und Adminer
* eine VM mit der MySQL Datenbank

### Übung
    
Terraform Initialisieren und Umgebung anlegen:

    terraform init
    terraform apply
    
Nach der Installation wird eine Intro Seite angezeigt mit weiteren Informationen.       

Werden die VMs nicht mehr benötigt können sie wie folgt gelöscht werden:

    terraform destroy
    
