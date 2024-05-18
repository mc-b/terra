## Übung 05-1: Terraform - Module

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

### Übung

#### Modul anlegen

Jedes Modul wird in einem eigenen Verzeichnis abgelegt und besteht mindestens aus den Dateien `main.tf` und `variables.tf`.

In diesem, sehr einfachen Beispiel, erstellen wir ein Modul um Dateien inkl. Inhalt zu erstellen.

Zuerst erstellen wir ein Verzeichnis `modules/create_local_file` und dort die Datei `variables.tf` mit folgendem Inhalt

    variable "name_of_file" {
      type        = string
      description = "Name of the file"
    }
    
    variable "content_of_file" {
      type        = string
      description = "Content of the file"
    }
   
Das sind die Argumente, welche dem Modul übergeben werden können.

In der Datei `modules/create_local_file/main.tf` kommen die eigentlichen Ressourcen, hier eine Datei

    resource "local_file" "lokale_Datei" {
      content  = var.content_of_file
      filename = var.name_of_file
    }
    
#### Hauptdeklaration

Nachdem das Modul erstellt wurde können wir diese Verwenden.

Dazu erstellen wir eine Datei `main.tf` mit folgendem Inhalt:

    module "Datei1" {
    
      # Wo liegt das Modul?
      source = "./modules/create_local_file"
    
      # Variablen für das Modul
      name_of_file    = "Datei1.txt"
      content_of_file = "Hallo Modul!\n"
    } 
    
Und Testen das Ganze:

Führt die Terraform Befehle zum Initialisieren, Vorschau und Erstellen der Ressource aus.

    terraform init
    terraform apply   

Es wurde eine Datei `Datei1.txt` erstellt.

#### Modul mehrmals verwenden

Soll das Modul mehrmals verwendet werden, z.B. um unterschiedliche Dateien mit unterschiedlichem Inhalt zu erstellen, können wir `main.tf` wie folgt ergänzen:

    module "Datei2" {
      source = "./modules/create_local_file"
    
      name_of_file    = "Datei2.txt"
      content_of_file = "Hallo Datei2!\n"
    }
    
    module "Datei3" {
      source = "./modules/create_local_file"
    
      name_of_file    = "Datei3.txt"
      content_of_file = "Hallo Datei3!\n"
    }
    
    module "Datei4" {
      source = "./modules/create_local_file"
    
      name_of_file    = "Datei4.txt"
      content_of_file = "Hallo Datei4!\n"
    }
    
#### Modul und `count`

Unterscheiden sich die Dateiinhalte, ausser einem Counter, nicht. Kann `count` verwendet werden. Datei ist `main.tf` wie folgt umzuschreiben:

    module "Dateien" {
      source = "./modules/create_local_file"
      count  = 4
    
      name_of_file    = "Datei${count.index + 1}.txt"
      content_of_file = "Hallo Datei${count.index + 1}!\n"
    }
  
#### Standardwerte

Nicht immer ist es sinnvoll, alle Argumente zu übergeben. Sehr oft sind die Argumente gleich. In unseren Fall, sind es die Zugriffsrechte für die Datei.

Um diese Problem zu lösen, kann mit `default`-Werten gearbeitet werden.

Dazu ist die Datei  `modules/create_local_file/variables.tf` wie folgt zu ergänzen:

    variable "file_permissions" {
      type        = string
      description = "Permissions of the file"
      default     = "0644"
    }        