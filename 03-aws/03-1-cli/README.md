## Übung 03-1: AWS CLI

Das AWS CLI (Command Line Interface) ermöglicht es, AWS-Dienste direkt über die Kommandozeile zu steuern. Damit kannst du Ressourcen wie S3, EC2 oder DynamoDB ohne Weboberfläche erstellen, verwalten und automatisieren.

Wir verwenden das AWS CLI, um erste Ressourcen in der AWS Cloud manuell zu erstellen. Diese werden anschliessend analysiert und in Terraform-Code überführt, damit sie reproduzierbar und automatisiert verwaltet werden können.

### Übung S3 Bucket und DynamoDB Tabelle erstellen

* S3 Bucket: wird direkt mit `create-bucket` erstellt, Tags müssen separat gesetzt werden
* DynamoDB: benötigt Schema (Attribute + Key), Tags ebenfalls separat
* `${TF_VAR_name_prefix}` entspricht deinem Terraform `var.name_prefix`

**S3 Bucket erstellen**

    aws s3api create-bucket \
      --bucket ${TF_VAR_name_prefix}-bucket \
      --region us-east-1

**DynamoDB Tabelle erstellen**

    aws dynamodb create-table \
      --table-name ${TF_VAR_name_prefix}-table \
      --attribute-definitions AttributeName=id,AttributeType=S \
      --key-schema AttributeName=id,KeyType=HASH \
      --billing-mode PAY_PER_REQUEST \
      --region us-east-1

**Kontrolle**

    aws s3 ls | grep ${TF_VAR_name_prefix}
    aws dynamodb list-tables | grep ${TF_VAR_name_prefix}
    
**Aufräumen**

Ein Bucket muss zuerst leer sein, sonst schlägt das Löschen fehl:

    aws s3 rm s3://${TF_VAR_name_prefix}-bucket --recursive

Danach den Bucket selbst löschen:

    aws s3api delete-bucket --bucket ${TF_VAR_name_prefix}-bucket --region us-east-1

DynamoDB Tabelle löschen

    aws dynamodb delete-table \
      --table-name ${TF_VAR_name_prefix}-table \
      --region us-east-1

### Übung virtuellen Maschinen (VMs) erstellen

Als Cloud-init Datei verwenden wir die gleiche YAML-Datei wie aus [Übung 1](../../01-iac/01-1-iac/cloud-init-nginx.yaml).

Mittels dieser Datei und dem jeweiligen Cloud CLI, erstellen wir eine neu VM.

Die Reihenfolge ist wie folgt:
* Security Group erstellen und Ports öffnen
* Erstellen der VM 


    
    aws ec2 create-security-group --group-name ${TF_VAR_name_prefix} --description "Standard Ports"
    aws ec2 authorize-security-group-ingress --group-name ${TF_VAR_name_prefix} --protocol tcp --port 22 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-name ${TF_VAR_name_prefix} --protocol tcp --port 80 --cidr 0.0.0.0/0   
        
    aws ec2 run-instances --image-id ami-053b0d53c279acc90 --security-group-ids ${TF_VAR_name_prefix} --instance-type t2.micro --count 1 --user-data file://cloud-init.yaml 

Anschliessend können wir uns die laufenden VMs anzeigen

    export AWS_PAGER=""
    aws ec2 describe-instances --output table   
    
Und die erstellte Security Group

    aws ec2 describe-security-groups --output table   
    
Um die Ausgaben mehr einzugrenzen, z.B. auf `InstanceId`, `SubnetId`, `VpcId` und `Public DNS`

    aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId, SubnetId, VpcId, PublicDnsName]" --output text
  
**Überprüft das Ergebnis, durch Anwählen der IP-Adresse Eurer VM im Browser.**

Um die erstellten Ressourcen zu löschen. VM und Security Group löschen, der Disk der VM wird automatisch gelöscht:

    aws ec2 terminate-instances --instance-ids <InstanceId>
    aws ec2 delete-security-group --group-id <ID-der-Security-Group>
    
Oder die Kurzform (nur Bash-Shell)
    
    aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --query "Reservations[*].Instances[*].InstanceId" --output text)
    aws ec2 delete-security-group --group-id $(aws ec2 describe-security-groups --group-names ${TF_VAR_name_prefix} --query "SecurityGroups[0].GroupId" --output text)
    
**Hinweis** AWS verwendet fortlaufende Nummern (oder auch eigendefinierte Schlüssel) um Ressourcen zu identifizieren. 
    
### Links

* [Schritt für Schritt Anleitung](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html)         
* [AWS CLI](https://aws.amazon.com/de/cli/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
