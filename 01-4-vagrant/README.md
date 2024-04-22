## Beispiel 01-4: Infrastruktur als Code mit Vagrant

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
        config.vm.boot_timeout = 360      
      
        # Konfiguriere den Provider, zum Beispiel VirtualBox oder VMware
        config.vm.provider "hyperv" do |vb|
          vb.memory = "4096" # Setze den Arbeitsspeicher auf 4 GB
          vb.cpus = 4 # Verwende 4 CPUs
        end
        
        # Keine SMB Verbindung aufbauen
        config.vm.synced_folder ".", "/vagrant", disabled: true    
      
        # Führe das PowerShell-Skript aus
        config.vm.provision "shell", inline: <<-POWERSHELL
            # PowerShell-Skript, um Chrome herunterzuladen und zu installieren
            $url = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
            $output = "$env:TEMP/ChromeInstaller.msi"
            
            # Chrome herunterladen
            Invoke-WebRequest -Uri $url -OutFile $output
            
            # Chrome installieren
            Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $output /qn /norestart" -Wait
            
            # Aufräumen
            Remove-Item $output
        POWERSHELL
      end

Starte die VM mittels

    vagrant up
    
Es sollte eine VM mit installiertem XML Notepad erstellt werden. User und Password sind `vagrant`.

Nach erfolgten Tests kann die VM wieder zerstört werden.

    vagrant destroy

Das `Vagrantfile` verwendet die Vagrant Box von [Gusztáv Varga](https://github.com/gusztavvargadr/packer/tree/master/samples/windows-10).    
    