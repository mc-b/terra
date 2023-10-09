## Übung 4: Terraform - Variablen

Die Übungen finden in der [Git/Bash](https://git-scm.com/downloads) statt. 

Öffnet die Git/Bash Umgebung oder VSCode und dort ein Terminal. Wechselt ins Arbeitsverzeichnis der Übung:

    cd 02-4-terraform
    
Kopiert die `main.tf` Datei von der Übung [02-3-terraform](../02-3-terraform/).

Erstellt eine neue Datei `variables.tf` mit folgendem Inhalt:

    variable "length" {
      description = "Laenge des Random Strings"
      type        = number
      default     = 16
    }
    
Und ändert `main.tf` wie folgt:

    resource "random_string" "zufallstext-1" {
      length  = var.length
      special = false
    }
    
    resource "random_string" "zufallstext-2" {
      length  = var.length
      special = false
    }
    
Testet es:

    terraform init
    terraform apply -auto-approve       
    
Alternativ zum fixen Wert `16` in `variables.tf` können wir den Wert mittels der Umgebungsvariable `TF_VAR_length` überschreiben.

 
    terraform destroy -auto-approve
    export TF_VAR_length=20
    terraform apply -auto-approve       
                  