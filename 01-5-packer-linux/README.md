## Übung 01-5: Erstellen von vorgefertigten Linux Maschinen-Images mit Packer

Eines der am häufigsten eingesetzten Tools zum Erstellen eines vorgefertigten Maschinen-Images ist [Packer](). 

Images sind in erster Linie Rechenressourcen, auf denen alle Konfigurationen, Metadaten, Artefakte und zugehörigen Dateien vorinstalliert/konfiguriert sind. 

Packer ist ein Open Source-Tool von HashiCorp, mit dem sich Maschinen-Images aus einer bestimmten Konfiguration erstellen lassen. Es automatisiert den gesamten Prozess der Maschinen-Image-Erstellung und beschleunigt so die Infrastruktur-bereitstellung. 

In dieser Übung erstellen wir Maschinen-Images für diverse Linuxe.

**Dazu wird folgende Software benötigt**:
* [Multipass](https://multipass.run/)
* [Packer](https://www.packer.io/)
* [Git/Bash](https://git-scm.com/downloads)

**Images erstellen**:

    packer init .
    packer build -on-error=ask -parallel-builds=1 .

**Die wichtigsten Dateien sind**:
* [plugins.pkr.hcl](plugins.pkr.hcl) - Deklaration der benötigten Packer Plug-Ins
* [alpine-mailserver.pkr.hcl](alpine-mailserver.pkr.hcl) - Packer Anweisungen um Alpine Linux mit Mailserver Postfix zu installieren
* [ubuntu-database.pkr.hcl](ubuntu-database.pkr.hcl) - Packer Anweisungen um Ubuntu Linux mit MySQL, Apache Webserver und Adminer (MySQL Weboberfläche) zu installieren

**Die wichtigsten Verzeichnisse**:
* [http](http/) - Startup Script, werden von Packer via integriertem Webserver zur Verfügung gestellt
* [output/](output) - Wo die erstellten VM Images abgelegt werden
* [packer_cache](packer_cache/) - Cache von Packer für die ISO-Images
* [scripts](scripts/) - weitere Script für die Installations von Services wie MySQL, Webserver etc.

**Packer Deklarationen**:

Installationsschritte (u.a. Tastatureingaben) für die Installation in *.pkr.hcl Dateien

     source "hyperv-iso" "alpine-mailserver" {
      boot_command                    = ["<enter><wait10>", "root<enter><wait>",
                                        "ifconfig eth0 up && udhcpc -i eth0<enter><wait>",
                                        "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/generic.alpine319.vagrant.cfg<enter><wait>",
                                        "sed -i -e \"/rc-service/d\" /sbin/setup-sshd<enter><wait>",
                                        "source generic.alpine319.vagrant.cfg<enter><wait>",
                                        "printf \"vagrant\\nvagrant\\n\" | sh /sbin/setup-alpine -f /root/generic.alpine319.vagrant.cfg && ",
                                        "mount /dev/sda2 /mnt && ",
                                        "sed -E -i '/#? ?PasswordAuthentication/d' /mnt/etc/ssh/sshd_config && ",


URL ISO-Image und Checksumme welche bei neuen Version ggf. angepasst werden müssen.

    iso_checksum                     = "sha256:366317d854d77fc5db3b2fd774f5e1e5db0a7ac210614fd39ddb555b09dbb344"
    iso_url                          = "https://mirrors.edge.kernel.org/alpine/v3.19/releases/x86_64/alpine-virt-3.19.1-x86_64.iso"
    
Weitere Installationsscripte oder Post Processoren:   

    build {
      sources = ["source.hyperv-iso.alpine-mailserver"]
    
      provisioner "shell" {
        execute_command     = "{{ .Vars }} /bin/ash '{{ .Path }}'"
        expect_disconnect   = "true"
        pause_before        = "2m0s"
        scripts             = ["scripts/alpine319/postfix.sh"]
        start_retry_timeout = "45m"
        timeout             = "2h0m0s"
      }
    } 

### Alpine Linux

Mit installiertem Mail Server Postfix.

* User    : root 
* Password: vagrant

### Ubuntu Linux

Mit Installiertem Datenbankserver MySQL.

* User:   : vagrant
* Password: vagrant

**MySQL**:

User    : root
Password: steht in Datei /root/.my.cnf

**Adminer**:

    http://<ip vm>/adminer
    
### Aufbereiten für GNS3

Bei Build werden automatisch Images für [GNS3](https://www.gns3.com/) erstellt.

Zusammen mit den Konfigurationsdateien im [gns3/](gns3/)-Verzeichnis können diese einfach in [GNS3](https://www.gns3.com/) eingebunden werden.

Vorgehen:
* Alle Dateien aus `output/..../Virtual Hard Disks/*.qcow2` auf GNS3 System ins Verzeichnis `/opt/gns3/images/QEMU` kopieren
* Alle Dateien im `gns3`-Verzeichnis auf GNS3 System kopieren.
* Wechsel auf GNS3 System, z.B. mittels `ssh`
* Eintragen der VM Images als Templates mittels `curl`

Die Befehle sind wie folgt:

    curl -X POST "http://localhost:3080/v2/templates" -d "@alpine-mailserver.json"
    curl -X POST "http://localhost:3080/v2/templates" -d "@alpine-mailserver.json"

### Links

* [Packer Beispiele für viele Betriebssysteme und Virtualsierungsumgebungen](https://github.com/chenhan1218/packer-desktop)
* [Bento Vagrant Boxen](https://github.com/chef/bento/tree/main)
* [Hyper-V Packer Plugin](https://developer.hashicorp.com/packer/integrations/hashicorp/hyperv/latest/components/builder/iso)
* [Packer templates, associated scripts, and configuration for creating deployable OS images for MAAS.](https://github.com/canonical/packer-maas/tree/main)
* [AlmaLinux OS Cloud Images is a project that contains Packer templates and other tools for building AlmaLinux OS images for various cloud platforms.](https://github.com/AlmaLinux/cloud-images)
* [Generic base boxes, providing a variety of operating systems, and available across a number of different virtualized platforms.](https://github.com/lavabit/robox/)
