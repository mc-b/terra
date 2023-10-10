## Übung 7: Terraform mit Multipass

Dazu Erstellen wir zwei VMs:
* eine VM mit dem Apache Web Server, PHP und Adminer
* eine VM mit der MySQL Datenbank

**Verbesserte Übung** mit mehr Variablen und weiterem Optimierungspotential, z.B. mittels Modulen.

Die Übungen finden in der [Git/Bash](https://git-scm.com/downloads) statt. 

Ausserdem müssen [Multipass](https://multipass.run/) und [Terraform](https://www.terraform.io/) installiert sein.

Öffnet die Git/Bash Umgebung oder VSCode und dort ein Terminal. Wechselt ins Arbeitsverzeichnis der Übung:

    cd 02-1-terraform
    
Terraform Initialisieren und Umgebung anlegen:

    terraform init
    terraform apply
    
Nach der Installation wird eine Introseite angezeigt mit weiteren Informationen.       
