## Übung 01-3: Infrastruktur als Code mit Vagrant

![](https://www.vagrantup.com/_next/image?url=https%3A%2F%2Fwww.datocms-assets.com%2F58478%2F1667241891-vagrant-illustration.png&w=3840&q=75)

Quelle: https://www.vagrantup.com/
- - - 

[Vagrant](https://www.vagrantup.com/) ist für jedermann als einfachste und schnellste Möglichkeit zum Erstellen einer virtualisierten Umgebung konzipiert.

Die Übungen finden in der [Windows PowerShell Umgebung](https://git-scm.com/downloads) als Administrator statt. 

Ausserdem muss das Produkt [Vagrant](https://www.vagrantup.com/) installiert sein.

Erstelle eine Datei `Vagrantfile` mit folgendem Inhalt:

    Vagrant.configure("2") do |config|
        # Verwende die Windows-Box
        config.vm.box = "gusztavvargadr/windows-10-22h2-enterprise"
      
        # Konfiguriere den Provider, zum Beispiel VirtualBox oder VMware
        config.vm.provider "hyperv" do |vb|
          vb.memory = "4096" # Setze den Arbeitsspeicher auf 4 GB
          vb.cpus = 4 # Verwende 4 CPUs
        end
      
        # Führe das PowerShell-Skript aus
        config.vm.provision "shell", inline: <<-SHELL
          # Installiere XML Notepad über winget
          winget install -e --id Microsoft.XMLNotepad
        SHELL
      end

Starte die VM mittels

    vagrant up
    
Es sollte eine VM mit installiertem XML Notepad erstellt werden. User und Password sind `vagrant`.

Nach erfolgten Tests kann die VM wieder zerstört werden.

    vagrant destroy
