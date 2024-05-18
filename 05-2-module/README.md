## Übung 05-2: Terraform - Module aus Git-Repository

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

### Übung

#### Modul anlegen

Die Module können direkt ab einen Git-Repository verwendet werden. Deshalb entfällt das Anlegen des Moduls.

Mögliche Module um VMs mit den dazugehörenden Netzwerk- und Firewall-Einstellungen zu erstellen sind:

* [https://github.com/mc-b/terraform-lerncloud-aws](https://github.com/mc-b/terraform-lerncloud-aws) - für die AWS Cloud
* [https://github.com/mc-b/terraform-lerncloud-azure](https://github.com/mc-b/terraform-lerncloud-azure) - für die Azure Cloud
* [https://github.com/mc-b/terraform-lerncloud-multipass](https://github.com/mc-b/terraform-lerncloud-multipass) - für die lokale Umgebung mit `multipass`
 
    
#### Hauptdeklaration

Nachdem wir uns entschieden haben, welches Modul wir verwenden wollen, wir dieses Verwenden. 

Damit Terraform weiss, dass das Modul aus einem Git-Repository zu holen ist, ist `git::` voranzustellen.

Für die Übung erstellen wir eine Datei `main.tf` mit folgendem Inhalt:

    module "myvm" {
      #source     = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
      #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
      #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure"
    
      # Module Info
      module      = "myvm-${terraform.workspace}"
      description = "Meine VM"
      userdata    = "cloud-init.yaml"

      # MAAS Server Access Info
      url = var.url
      key = var.key
      vpn = var.vpn        
    }
    
Je nach gewünschter Cloud ist einer der `source` Einträge zu aktiveren, d.h. Kommentarzeichen `#` entfernen.    

**Ausserdem können folgende Variablen werden**
* module - der Name der VM
* description - Kommentar zu VM
* userdata - Pfad zu einer Cloud-init Datei
und Optional
* memory - von 2 - 8 GB
* core - Anzahl CPU Cores 
* storage - Grösser des persistenten Speichers
* ports - Ports als Array, z.B. [ 22, 80 ], welche gegen Aussen geöffnet werden sollen.

Ändert bzw. aktiviert und deaktiviert die `source` Einträge und führt jeweils `terraform init` und `terraform plan` aus.

Analysiert die Ausgaben von `terraform plan`

**Hinweis**: Wir verzichten extra auf `terraform apply` um nicht unnötig Cloud Kosten zu verursachen.

#### Modul und `count`

Durch einfügen von `count` können auch mehrere VMs erstellt werden.

Dazu `main.tf`, Eintrag `module` einen Zähler und den Eintrag `count` erweitern. 
    
    module "myvm" {
      source     = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
      #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
      #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure"
    
      module      = "myvm-${count.index + 1}-${terraform.workspace}"
      description = "Meine VM"
      userdata    = "cloud-init.yaml"
      
      count     = 3
    }

#### Tips & Tricks

Zum Testen eines Modul, gehen wir wie folgt vor:

Clonen es Modul in ein lokale Verzeichnis, z.B. `terraform-lerncloud-module`.

    git clone https://github.com/mc-b/terraform-lerncloud-azure terraform-lerncloud-module
    
Ändern der Source auf:    

    source      = "./terraform-lerncloud-module"
      
Nun kann das Modul ausgiebig getestet werden und evtl. Änderungen wieder ins Git-Repository gepusht werden.      


       