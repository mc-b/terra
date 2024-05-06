## Übung 01-5: Erstellen von vorgefertigten Windows Maschinen-Images - Packer

Eines der am häufigsten eingesetzten Tools zum Erstellen eines vorgefertigten Maschinen-Images ist [Packer](). 

Images sind in erster Linie Rechenressourcen, auf denen alle Konfigurationen, Metadaten, Artefakte und zugehörigen Dateien vorinstalliert/konfiguriert sind. 

Packer ist ein Open Source-Tool von HashiCorp, mit dem sich Maschinen-Images aus einer bestimmten Konfiguration erstellen lassen. Es automatisiert den gesamten Prozess der Maschinen-Image-Erstellung und beschleunigt so die Infrastruktur-bereitstellung. 

Die nachfolgenden Beispiele basieren auf der ausgezeichneten Arbeit von [Stefan Scherer](https://github.com/StefanScherer/packer-windows). Zu Schulungszwecken wurden sie jedoch stark vereinfacht.

Die Umbauten sind wie folgt:
* es wird nur Windows 10 und Windows Server 2022 unterstützt.
* die Dateien liegen im HCL statt im JSON Format vor.
* als Hypervisor kommt auschliesslich Hyper-V zum Einsatz.
* alle nicht direkt benötigten Dateien wurden entfernt.
* Windows Updates beim Installieren deaktiviert

In dieser Übung erstellen wir ein Maschinen-Image für Windows 10 und Windows Server 2022 mit Packer und Hyper-V. 

### Maschinen-Image erstellen

**Hyper-V Plug-In installieren**:

    packer init plugins.pkr.hcl
    
**Für ein Windows 10 Image**:

Zeitbedarf, ca. 20 Minuten.
    
    packer build windows_10.pkr.hcl
    
**Für Windows 2022 Server**:

Zeitbedarf, ca. 20 Minuten.

    packer build windows_2022.pkr.hcl
    
**Die wichtigsten Dateien sind**:
* [plugins.pkr.hcl](plugins.pkr.hcl) - Deklaration der benötigten Packer Plug-Ins
* [windows_10.pkr.hcl](windows_10.pkr.hcl) - Packer Anweisungen um Windows 10 zu installieren
* [windows_2022.pkr.hcl](windows_2022.pkr.hcl) - Packer Anweisungen um Windows Server 2022 zu installieren

**Die wichtigsten Verzeichnisse**:
* [answer_files](answer_files/) - Konfigurationen für "Unattended Installation for Windows"
* output-XXXXX - Wo die erstellten VM Images abgelegt werden
* [packer_cache](packer_cache/) - Cache von Packer für die ISO-Images
* [floppy](floppy/) und [scripts](scripts/) - weitere Script für das Feintuning von Windows.  

**Packer Deklarationen**:

Installationsschritte 

    source "hyperv-iso" "windows_10" {
      boot_wait             = "6m"
      communicator          = "winrm"
      configuration_version = "8.0"
      cpus                  = "2"
      disk_size             = "${var.disk_size}"
      floppy_files          = ["${var.autounattend}", 
                              "./floppy/WindowsPowershell.lnk", 
                              "./floppy/PinTo10.exe", 
                              "./scripts/fixnetwork.ps1", 
                              "./scripts/disable-screensaver.ps1", 
                              "./scripts/disable-winrm.ps1", 
                              "./scripts/enable-winrm.ps1", 
                              "./scripts/microsoft-updates.bat", 
                              "./scripts/win-updates.ps1"]
                                          
URL ISO-Image und Checksumme welche bei neuen Version ggf. angepasst werden müssen.

    variable "iso_checksum" {
      type    = string
      default = "sha256:ef7312733a9f5d7d51cfa04ac497671995674ca5e1058d5164d6028f0938d668"
    }
    
    variable "iso_url" {
      type    = string
      default = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
    }    
    
Weitere Installationsscripte oder Post Processoren:   

    build {
      sources = ["source.hyperv-iso.windows_10"]
    
      provisioner "windows-shell" {
        execute_command = "{{ .Vars }} cmd /c \"{{ .Path }}\""
        remote_path     = "/tmp/script.bat"
        scripts         = ["./scripts/enable-rdp.bat"]
      }
   
### Maschinen (VM) Images verwenden

Öffnet den Hyper-V Manager und wählt "Virtuellen Computer importieren". Die Maschinen (VM) Images befinden sich im Verzeichnis `output-XXXXX`.
Bis am Schluss verwendet überall die Standardeinstellungen, dann wählt "Computer kopieren". So könnt Ihr beliebe VMs ab dem Images erstellen.    
    
### Aufbereiten für GNS3

Bei Build werden automatisch Images für [GNS3](https://www.gns3.com/) erstellt.

Zusammen mit den Konfigurationsdateien im [gns3/](gns3/)-Verzeichnis können diese einfach in [GNS3](https://www.gns3.com/) eingebunden werden.

Vorgehen:
* Alle Dateien von `output-windows.../..../Virtual Hard Disks/*.qcow2` auf GNS3 System ins Verzeichnis `/opt/gns3/images/QEMU` kopieren
* Alle Dateien im `gns3`-Verzeichnis auf GNS3 System kopieren.
* Wechsel auf GNS3 System, z.B. mittels `ssh`
* Eintragen der VM Images als Templates mittels `curl`

Die Befehle sind wie folgt:

    curl -X POST "http://localhost:3080/v2/templates" -d "@windows_10.json"
    curl -X POST "http://localhost:3080/v2/templates" -d "@windows_2022.json"

### Links

* [Anleitung: Windows 10 Installation automatisieren mit autounattend.xml Datei](https://www.youtube.com/watch?v=ChOR0BgGdIA)
* [Unattended Installation for Windows](https://developer.hashicorp.com/packer/guides/automatic-operating-system-installs/autounattend_windows)
* [Windows Answer File Generator](https://www.windowsafg.com/win10x86_x64_uefi.html)
* [Packer Plug-In: Hyper-V ISO](https://developer.hashicorp.com/packer/integrations/hashicorp/hyperv/latest/components/builder/iso)
* [Stefan Scherer Beispiele](https://github.com/StefanScherer/packer-windows)
