## Übung 05-4: Terraform - Module aus der Terraform Module Registry

Die Übungen finden in der [Git/Bash](https://git-scm.com/downloads) statt. 

Öffnet die Git/Bash Umgebung oder VSCode und dort ein Terminal. Wechselt ins Arbeitsverzeichnis der Übung:

    cd 05-4-module

### Modul anlegen

Die Module können direkt ab der [Terraform Module Registry](https://registry.terraform.io/browse/modules) verwendet werden. Deshalb entfällt das Anlegen des Moduls.

Mögliche Module um VMs mit den dazugehörenden Netzwerk- und Firewall-Einstellungen zu erstellen sind:

* [mc-b/aws/lerncloud](https://registry.terraform.io/modules/mc-b/aws/lerncloud/latest) - für die AWS Cloud
* [mc-b/azure/lerncloud](https://registry.terraform.io/modules/mc-b/azure/lerncloud/latest) - für die Azure Cloud
* [mc-b/multipass/lerncloud](https://registry.terraform.io/modules/mc-b/multipass/lerncloud/latest) - für die lokale Umgebung mit `multipass`
 
    
### Hauptdeklaration

Nachdem wir uns entschieden haben, welches Modul wir verwenden wollen, wir dieses Verwenden. 

Für die Übung erstellen wir eine Datei `main.tf` mit folgendem Inhalt:

    module "myvm" {
      #source     = "mc-b/aws/lerncloud"
      #source     = "mc-b/azure/lerncloud"
      #source     = "mc-b/multipass/lerncloud"
    
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

Folgende Variablen können gesetzt werden:
* module - der Name der VM
* description - Kommentar zu VM
* userdata - Pfad zu einer Cloud-init Datei
und Optional
* memory - von 2 - 8 GB
* core - Anzahl CPU Cores 
* storage - Grösser des persistenten Speichers
* ports - Ports als Array, z.B. [ 22, 80 ], welche gegen Aussen geöffnet werden sollen.

Zum Schluss testen wir unsere Deklaration

    terraform init
    terraform plan
    terraform apply   

### Modul und `count`

Durch einfügen von `count` können auch mehrere VMs erstellt werden.

Dazu `main.tf`, Eintrag `module` einen Zähler und den Eintrag `count` erweitern. 

    
    module "myvm" {
      #source     = "mc-b/aws/lerncloud"
      #source     = "mc-b/azure/lerncloud"
      #source     = "mc-b/multipass/lerncloud"
    
      module      = "myvm-${count.index + 1}-${terraform.workspace}"
      description = "Meine VM"
      userdata    = "cloud-init.yaml"
      
      count     = 3

      # MAAS Server Access Info
      url = var.url
      key = var.key
      vpn = var.vpn        
    }

### Tips & Tricks

Zum Testen eines Modul, gehen wir wie folgt vor.

Öffnen der Modulbeschreibung
* [mc-b/aws/lerncloud](https://registry.terraform.io/modules/mc-b/aws/lerncloud/latest) - für die AWS Cloud
* [mc-b/azure/lerncloud](https://registry.terraform.io/modules/mc-b/azure/lerncloud/latest) - für die Azure Cloud
* [mc-b/multipass/lerncloud](https://registry.terraform.io/modules/mc-b/multipass/lerncloud/latest) - für die lokale Umgebung mit `multipass`

Dort steht der Verweis auf ein entsprechendes Git Repository. Dieses ist dann in ein lokales Verzeichnis, z.B. `terraform-lerncloud-module` zu clonen, z.B.:

    git clone https://github.com/mc-b/terraform-lerncloud-azure terraform-lerncloud-module
    
Ändern der Source auf:    

      source      = "./terraform-lerncloud-module"
      
Nun kann das Modul ausgiebig getestet werden und evtl. Änderungen wieder ins Git-Repository gepusht werden.      


       