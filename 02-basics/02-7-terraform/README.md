## Übung 02-7: Terraform mit Multipass

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem müssen [Multipass](https://multipass.run/) und [Terraform](https://www.terraform.io/) installiert sein.

### Übung

Dazu Erstellen wir zwei VMs:
* eine VM mit dem Apache Web Server, PHP und Adminer
* eine VM mit der MySQL Datenbank

**Verbesserte Übung 02-01-terraform** mit mehr [Variablen](variables.tf) und weiterem Optimierungspotential, z.B. mittels [Modulen](main.tf).
    
Terraform Initialisieren und Umgebung anlegen:

    terraform init
    terraform apply
    
Nach der Installation wird eine Intro Seite angezeigt mit weiteren Informationen.       
