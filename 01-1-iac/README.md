## Übung 01-1: Infrastruktur als Code

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das Produkt [Multipass](https://multipass.run/) installiert sein.

### VM mit NGINX Server

    multipass launch --name nginx --cloud-init cloud-init-nginx.yaml
    
Nach erfolgter Installation öffnet einen Browser und wählt [http://nginx.mshome.net](http://nginx.mshome.net) an.    

### VM mit einer PHP Seite

    multipass launch --name php --cloud-init cloud-init-php.yaml
    
Nach erfolgter Installation öffnet einen Browser und wählt [http://php.mshome.net](http://php.mshome.net) an.        
    
### Aufräumen

Werden die VMs nicht mehr benötigt können sie wie folgt gelöscht werden:

    multipass delete nginx --purge
    multipass delete php --purge
   
**Links**

* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
* [How To Use Cloud-Config For Your Initial Server Setup](https://www.digitalocean.com/community/tutorials/how-to-use-cloud-config-for-your-initial-server-setup)
