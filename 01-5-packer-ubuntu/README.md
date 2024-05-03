## Übung 01-5: Erstellen von vorgefertigten Ubuntu Maschinen-Images - Packer

Eines der am häufigsten eingesetzten Tools zum Erstellen eines vorgefertigten Maschinen-Images ist [Packer](). 

Images sind in erster Linie Rechenressourcen, auf denen alle Konfigurationen, Metadaten, Artefakte und zugehörigen Dateien vorinstalliert/konfiguriert sind. 

Packer ist ein Open Source-Tool von HashiCorp, mit dem sich Maschinen-Images aus einer bestimmten Konfiguration erstellen lassen. Es automatisiert den gesamten Prozess der Maschinen-Image-Erstellung und beschleunigt so die Infrastruktur-bereitstellung. 

In dieser Übung erstellen ein Maschinen-Image für Ubuntu 20 Server mittels Packer und Hyper-V. Neuere Ubuntu Versionen funktionieren leider nicht mehr, weil der Installationsprozess geändert wurde.

Canonical schreibt dazu:

    Legacy Ubuntu Server deprecation notice
    From Ubuntu 20.04 LTS onwards, the Ubuntu Server Live Installer is the preferred installation media for Ubuntu Server installs, and the legacy installer based on debian-installer is deprecated

Als Input verwenden wir eine Standard ISO-Datei von der Ubuntu Download Seite [http://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04/release/](http://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04/release/).

Als Output wird ein Hyper-V kompatibles Maschinen-Image erstellt, welcher im Hyper-V Manager mittels "Virtuellen Computer importieren" importiert werden kann.

**Die wichtigsten Dateien sind:**
* [ubuntu-20-server.pkr.hcl](ubuntu-20-server.pkr.hcl) - Packer Deklarationen
* [preseed-hyperv.cfg](preseed-hyperv.cfg) - Anweisungen im Debian Format für die Installation von Ubuntu 20 legacy.
* [plugins.pkr.hcl](plugins.pkr.hcl) - Packer Deklarationen für Plug-Ins.

### Maschinen-Image erstellen

    packer init .
    packer build .
    
Der Output, ein Hyper-V Maschinen-Image, steht im Verzeichnis `output-ubuntu_20_server`. 

**Hinweis**: Falls die VM nicht von selber herunterfährt, verbinden mittels `ssh ubuntu@<ip-addresse>`, Password ist `insecure` und `sudo -S -E shutdown -P now` ausführen.

### Packer Deklarationen

Installationsschritte (u.a. Tastatureingaben) für Ubuntu Server 20 Legacy Installation

    source "hyperv-iso" "ubuntu_20_server" {
      boot_command       = ["<esc><wait10><esc><esc><enter><wait>", "set gfxpayload=1024x768<enter>", "linux /install/vmlinuz ", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed-hyperv.cfg ", "debian-installer=en_US.UTF-8 auto locale=en_US.UTF-8 kbd-chooser/method=us ", "hostname={{ .Name }} ", "fb=false debconf/frontend=noninteractive ", "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ", "keyboard-configuration/variant=USA console-setup/ask_detect=false <enter>", "initrd /install/initrd.gz<enter>", "boot<enter>"]

Variable und Checksumme welche bei neuen Version ggf. angepasst werden müssen.

    variable "iso_url" {
      type    = string
      default = "http://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04/release/ubuntu-20.04.1-legacy-server-amd64.iso"
    }      
      
    variable "iso_checksum" {
      type    = string
      default = "f11bda2f2caed8f420802b59f382c25160b114ccc665dbac9c5046e7fceaced2"
    }

Schritte nachdem Ubuntu Server 20 Legacy erstellt wurde:

    build {
      sources = ["source.hyperv-iso.ubuntu_20_server"]
    }
    
Hier könnten z.B. weitere Installationsscripte oder Post Processoren stehen:

    build {
      sources = ["source.hyperv-iso.ubuntu_20_server"]
      provisioner "shell" {
        environment_vars  = ["HOME_DIR=/home/vagrant", "http_proxy=${var.http_proxy}", "https_proxy=${var.https_proxy}", "no_proxy=${var.no_proxy}"]
        execute_command   = "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
        expect_disconnect = true
        scripts           = ["${path.root}/scripts/update.sh", "${path.root}/../_common/motd.sh", "${path.root}/../_common/sshd.sh", "${path.root}/scripts/networking.sh", "${path.root}/scripts/sudoers.sh", "${path.root}/scripts/desktop.sh", "${path.root}/scripts/vagrant.sh", "${path.root}/../_common/virtualbox.sh", "${path.root}/scripts/vmware.sh", "${path.root}/../_common/parallels.sh", "${path.root}/scripts/hyperv.sh", "${path.root}/../_common/minimize.sh"]
      }
    
      post-processor "vagrant" {
        output               = "${var.build_directory}/${var.box_basename}.{{ .Provider }}.box"
        vagrantfile_template = "vagrantfile_templates/ubuntu-desktop.rb"
      }
    }    

### Links

* [Packer Beispiele für viele Betriebssysteme und Virtualsierungsumgebungen](https://github.com/chenhan1218/packer-desktop)
* [Bento Vagrant Boxen](https://github.com/chef/bento/tree/main)
* [Hyper-V Packer Plugin](https://developer.hashicorp.com/packer/integrations/hashicorp/hyperv/latest/components/builder/iso)
* [Packer templates, associated scripts, and configuration for creating deployable OS images for MAAS.](https://github.com/canonical/packer-maas/tree/main)
* [AlmaLinux OS Cloud Images is a project that contains Packer templates and other tools for building AlmaLinux OS images for various cloud platforms.](https://github.com/AlmaLinux/cloud-images)
* [Generic base boxes, providing a variety of operating systems, and available across a number of different virtualized platforms.](https://github.com/lavabit/robox/)

