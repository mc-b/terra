## Übung 05-3: Terraform - Module Outputs

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

### Übung

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


       