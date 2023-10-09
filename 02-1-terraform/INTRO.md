Infrastruktur als Code
======================

Cloud-init und PHP 
------------------

* Web Server (apache2) mit der PHP Erweiterung.
* MySQL Web Oberfläche [Adminer](https://www.adminer.org/), um nachher auf eine zweite VM mit MySQL zuzugreifen.
    
    
Cloud-init MySQL Datenbank
--------------------------

    http://${fqdn}/adminer oder http://${ip}/adminer

* Datenbank System: MySQL
* Server          : ${mysql} oder ${mysql_ip}
* Benutzer        : myuser
* Passwort        : mypass
* Datenbank       :   

        
Mehr Informationen siehe [README.md](README.md)    
