## Übung 03-2: AWS - Terraform Import

### Übung Import

In dieser Übung werden die in der vorherigen Übung erstellten AWS-Ressourcen aus [Übung 1](../03-1-aws/) in Terraform übernommen.

Dazu verwenden wir die neue Import-Variante von Terraform.

Erstellen einer Datei `provider.tf`, für den AWS Provider, mit folgenden Inhalt    

    terraform {
      required_version = ">= 1.5.0"
    
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.0"
        }
        local = {
          source  = "hashicorp/local"
          version = "~> 2.5"
        }
      }
    }
    provider "aws" {
      region = "us-east-1"
    }
    
Und eine minimale `variables.tf`

    variable "name_prefix" {
      type = string
    }    
    
Initialisierung des Providers

    terraform init    

Terraform kann bestehende Ressourcen nicht nur importieren, sondern auch die passende Konfiguration automatisch generieren.

Dazu werden Import-Blöcke definiert, und Terraform erstellt daraus eine fertige main.tf.

Erstelle zuerst eine Datei import.tf:

    import {
      to = aws_s3_bucket.example
      id = "${var.name_prefix}-bucket"
    }
    
    import {
      to = aws_dynamodb_table.example
      id = "${var.name_prefix}-table"
    }
    
Führe anschliessend folgenden Befehl aus:

    terraform plan -generate-config-out=main.tf

Terraform analysiert die bestehenden Ressourcen und erstellt automatisch eine Konfigurationsdatei (main.tf).

Diese Datei enthält die notwendigen Attribute, um die Ressourcen vollständig mit Terraform zu verwalten.    

**Hinweis**

Die generierte Konfiguration ist oft sehr detailliert und enthält auch Werte, die du normalerweise nicht selbst definieren würdest. Ziel ist es, die Datei zu vereinfachen und an deine bestehende Struktur anzupassen.

### Import Virtuelle Maschine

Erweitert die Datei `import.tf` und fügt alle zu Importierenden Ressourcen mit Ids in die Datei ein:

    import {
        to  = aws_instance.main
        id  = "i-..."
    }
    
    import {
        to  = aws_subnet.main
        id  = "subnet-..."
    } 
    
    import {
        to  = aws_vpc.main
        id  = "vpc-..."
    }    
    
    import {
        to  = aws_security_group.main
        id  = "sg-..."
    }  

Die Ids können wie folgt abgefragt werden:
    
    aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId, SubnetId, VpcId, PublicDnsName]" --output text
    aws ec2 describe-security-groups --group-names mygroup --query "SecurityGroups[0].GroupId" --output text    

Mittels `terraform plan` können die entsprechenden Terraform Deklaration automatisch erstellt werden:

    terraform plan -generate-config-out main.tf

### Links

* [Schritt für Schritt Anleitung](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html)         
* [AWS CLI](https://aws.amazon.com/de/cli/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
* [Neue Import Variante](https://www.youtube.com/watch?v=znfh_00EDZ0&ab_channel=NedintheCloud)

