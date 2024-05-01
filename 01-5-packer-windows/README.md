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

Hyper-V Plug-In installieren

    packer init plugins.pkr.hcl
    
**Für ein Windows 10 Image**:

Zeitbedarf, ca. 20 Minuten.
    
    packer build windows_10.pkr.hcl
    
**Für Windows 2022 Server**:

Zeitbedarf, ca. 45 Minuten.

    packer build windows_2022.pkr.hcl
    
