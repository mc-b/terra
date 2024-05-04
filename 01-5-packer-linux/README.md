## Übung 01-5: Erstellen von vorgefertigten Linux Maschinen-Images - Packer

Eines der am häufigsten eingesetzten Tools zum Erstellen eines vorgefertigten Maschinen-Images ist [Packer](). 

Images sind in erster Linie Rechenressourcen, auf denen alle Konfigurationen, Metadaten, Artefakte und zugehörigen Dateien vorinstalliert/konfiguriert sind. 

Packer ist ein Open Source-Tool von HashiCorp, mit dem sich Maschinen-Images aus einer bestimmten Konfiguration erstellen lassen. Es automatisiert den gesamten Prozess der Maschinen-Image-Erstellung und beschleunigt so die Infrastruktur-bereitstellung. 

In dieser Übung erstellen Maschinen-Images für diverse Linuxe.

### Alpine Linux

Mit installiertem Mail Server Postfix.

User    : root 
Password: vagrant

**Image erstellen**:

    packer init .
    packer build -on-error=ask -parallel-builds=1 .

### Ubuntu Linux

Mit Installiertem Datenbankserver MySQL.

User:   : vagrant
Password: vagrant

**MySQL**:

User    : root
Password: steht in Datei /root/.my.cnf

**Adminer**:

    http://ubuntu-database.mshome.net/adminer



