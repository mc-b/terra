## Übung 03-4: AWS CLI

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [AWS CLI](https://aws.amazon.com/de/cli/) installiert sein.

### Einleitung

Als Cloud-init Datei verwenden wir die gleiche YAML-Datei wie aus [Übung 1](../01-1-iac/cloud-init-nginx.yaml).

Mittels dieser Datei und dem jeweiligen Cloud CLI, erstellen wir eine neu VM.

### Übung

Zuerst muss AWS so konfiguriert werden, dass wir das AWS CLI verwenden können.

Die Schritte sind wie folgt:
* Anmelden in der AWS Console mittels Stammbenutzer (root)
* Pulldown rechts beim Usernamen -> Sicherheitsanmeldeinformationen
* Einen neuen Zugriffsschlüssel anlegen
* Id und Secret Access Key notieren, die brauchen wir für `aws configure` unten.

Einloggen in AWS Cloud

    aws configure
 
    AWS Access Key ID [****************WBM7]:
    AWS Secret Access Key [****************eKJA]:
    Default region name [us-east-1]:
    Default output format [None]:
    
Anschliessend müssen folgende Aktionen ausgeführt werden:
* Security Group erstellen und Ports öffnen
* Erstellen der VM 

<pre>
aws ec2 create-security-group --group-name mygroup --description "Standard Ports"
aws ec2 authorize-security-group-ingress --group-name mygroup --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name mygroup --protocol tcp --port 80 --cidr 0.0.0.0/0   
    
aws ec2 run-instances --image-id ami-053b0d53c279acc90 --security-group-ids mygroup --instance-type t2.micro --count 1 --user-data file://cloud-init.yaml 
</pre>

Anschliessend können wir uns die laufenden VMs anzeigen

    aws ec2 describe-instances --output table   
    
Und die erstellte Security Group

    aws ec2 describe-security-groups
    
**Überprüft das Ergebnis, durch Anwählen der IP-Adresse Eurer VM im Browser.**

Um die erstellten Ressourcen zu löschen. VM und Security Group löschen, der Disk der VM wird automatisch gelöscht:

    aws ec2 terminate-instances --instance-ids <InstanceId>
    aws ec2 delete-security-group --group-id <ID-der-Security-Group>
    
**Hinweis** AWS verwendet fortlaufende Nummern (oder auch eigendefinierte Schlüssel) um Ressourcen zu identifizieren. Deshalb ist 
    
### Links

* [Schritt für Schritt Anleitung](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html)         
* [AWS CLI](https://aws.amazon.com/de/cli/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
