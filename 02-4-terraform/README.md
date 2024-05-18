## Übung 02-4: Terraform - Variablen

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

### Übung
    
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

**Umgebungsvariablen**

Alternativ zum fixen Wert `16` in `variables.tf` können wir den Wert mittels der Umgebungsvariable `TF_VAR_length` überschreiben.
 
    terraform destroy -auto-approve
    export TF_VAR_length=20
    terraform apply -auto-approve       

**count**

Jetzt haben wir zwei Ressourcen beschrieben, welche gleich aufgebaut sein. Da bietet sich `count` an.

Alle Ressourcen zerstören

    terraform destroy -auto-approve

Ändern von `main.tf`:

    resource "random_string" "zufallstext" {
      length  = var.length
      special = false
      count   = 2
    }

Ressourcen (als Array) erstellen:

    terraform apply -auto-approve 
    
Nach einer Weile stellen wir fest, dass wir neu 10 Strings brauchen. Dazu ändern wir `main.tf` wie folgt `count = 10` und führen die Änderungen nach.

    terraform apply -auto-approve 
    
Wieder nach einer Weile, brauchen wir doch nur zwei. Darum ändern wir `main.tf` wie folgt `count = 2` und führen wieder die Änderungen nach.

    terraform apply -auto-approve 
           
