## Übung 1: AWS CLI

Als Cloud-init Datei verwenden wir die gleiche YAML-Datei wie aus [Übung 1](../01-1-iac/cloud-init-nginx.yaml).

Mittels dieser Datei und dem jeweiligen Cloud CLI, erstellen wir eine neu VM.

### Vorgehen

Zuerst muss AWS so konfiguriert werden, dass wir das AWS CLI verwenden können.

Die Anleitung finden wir [hier](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

Wechsel in das Arbeitsverzeichnis

    cd 03-1-aws

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
    
aws ec2 run-instances --image-id ami-0767046d1677be5a0 --security-group-ids mygroup --instance-type t2.micro --count 1 --user-data file://cloud-init.yaml 
</pre>

Anschliessend können wir uns die laufenden VMs anzeigen

    aws ec2 describe-instances --output table    
    
**Überprüft das Ergebnis, durch Anwählen der IP-Adresse Eurer VM im Browser.**
    
### Links

* [Schritt für Schritt Anleitung](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html)         
* [AWS CLI](https://aws.amazon.com/de/cli/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
