## Übung 03-5: AWS - Terraform Import

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [AWS CLI](https://aws.amazon.com/de/cli/) installiert sein.

### Übung

In dieser Übung wollen wir die erstellten AWS Ressourcen aus [Übung 4](../03-4-aws/) nach Terraform überführen.

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

Um die VM zu importieren, brauchen wir deren `id`. Deshalb zeigen wir mit dem AWS CLI zuerst deren Informationen an:

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
        
#### Restliche Ressourcen

Für die restlichen Ressourcen wie
- Netzwerk
- Firewall
etc. bleibt das Vorgehen gleich.

Die benötigten Metadaten sind in `main.tf` zu überführen, variable Werte durch Variablen `variables.tf` ersetzen und mit den bekannten Terraform Befehlen testen.

### Variante 2 - Experimentell

Erstellt eine Datei `import.tf` und fügt alle zu Importierenden Ressourcen, im nachfolgenden Format, in die Datei ein:

    import {
        to  = aws_instance.main
        id  = "i-01da79e473269858d"
    }

Mittels `terraform plan` können die entsprechenden Terraform Deklaration automatisch erstellt werden:

    terraform plan -generate-config-out main.tf
 
### Links

### Links

* [Schritt für Schritt Anleitung](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html)         
* [AWS CLI](https://aws.amazon.com/de/cli/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
* [Neue Import Variante](https://www.youtube.com/watch?v=znfh_00EDZ0&ab_channel=NedintheCloud)

