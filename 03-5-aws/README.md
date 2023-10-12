## Übung 2: AWS - Terraform Import

In dieser Übung wollen wir die erstellten AWS Ressourcen aus [Übung 4](../03-4-aws/) nach Terraform überführen.

Wechsel in das Arbeitsverzeichnis

    cd 03-5-aws
    
Erstellen einer Datei `provider.tf`, für den AWS Provider, mit folgenden Inhalt    

    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 3.27"
        }
      }
    
      required_version = ">= 0.14.9"
    }
    
    
    provider "aws" {
      profile = "default"
      region  = "us-east-1"
    }
    
Initialisierung des Providers

    terraform init    

Einloggen in AWS Cloud

    aws configure
 
    AWS Access Key ID [****************WBM7]:
    AWS Secret Access Key [****************eKJA]:
    Default region name [us-east-1]:
    Default output format [None]:
    

### Virtuelle Maschine

Um die Ressource Gruppe zu importieren, brauchen wir deren `id`. Deshalb zeigen wir mit dem Azure CLI zuerst deren Informationen an:

    aws ec2 describe-instances 
    
Die Ausgabe sieht in etwa so aus:

    {
        "Reservations": [
            {
                "Groups": [],
                "Instances": [
                    {
                        "AmiLaunchIndex": 0,
                        "ImageId": "ami-053b0d53c279acc90",
                        "InstanceId": "i-03dd68244cb5c33ce",
       
Import 

    terraform import aws_instance.myvm i-03dd68244cb5c33ce
 
    
Deklaration

    terraform state show aws_instance.myvm        
        
### Restliche Ressourcen

Für die restlichen Ressourcen wie
- Netzwerk
- Firewall
etc. bleibt das Vorgehen gleich.

Die benötigten Metadaten sind in `main.tf` zu überführen, variable Werte durch Variablen `variables.tf` ersetzen und mit den bekannten Terraform Befehlen testen.
 
### Links

### Links

* [Schritt für Schritt Anleitung](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html)         
* [AWS CLI](https://aws.amazon.com/de/cli/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
