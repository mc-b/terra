## Übung 3: Terraform - Module Outputs

Die Übungen finden in der [Git/Bash](https://git-scm.com/downloads) statt. 

Öffnet die Git/Bash Umgebung oder VSCode und dort ein Terminal. Wechselt ins Arbeitsverzeichnis der Übung:

    cd 05-3-module

Was uns noch fehlt sind Output-Werte über unsere VMs wie:
* IP-Adressen
* DNS-Namen.

Durch Hinzufügen einer Datei `output.tf` können diese Ausgegeben werden.

    #   Outputs wie IP-Adresse und DNS Name
    output "ip_vm" {
      value = module.myvm.*.ip_vm
      description = "The IP address of the server instance."
    }
    output "fqdn_vm" {
      value = module.myvm.*.fqdn_vm
      description = "The FQDN of the server instance."
    }
 
Voraussetzung ist, dass das Modul ebenfalls eine `output.tf` Deklaration besitzt, wo diese Werte gesetzt werden.

Erweitert die vorherige Übung [05-2](../05-2-module) um eine Datei `output.tf`. 

Als Zusatzaufgabe, erweitert die Datei `INTRO.md` um einen sinnvollen Text, welcher die erstellte VMs beschreibt.


       