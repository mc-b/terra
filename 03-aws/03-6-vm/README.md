## Übung 03-6: AWS - Einfache VM mit EC2

### Übung

Dieses Beispiel zeigt eine minimal gestartete virtuelle Maschine auf AWS mit Terraform/OpenTofu. Die VM wird als EC2-Instanz erstellt und eignet sich für einfache Tests, Login-Übungen oder grundlegende Serveraufgaben.

* Verständnis für virtuelle Maschinen in AWS
* Starten einer EC2-Instanz mit einem Ubuntu-Image
* Arbeiten mit einer klassischen Compute-Ressource statt serverlosen Diensten

### Architektur

* **EC2 Instance**: stellt die virtuelle Maschine bereit
* **AMI**: definiert das verwendete Ubuntu-Image
* **Instance Type**: bestimmt CPU- und RAM-Ausstattung der VM

In diesem Beispiel wird eine einzelne EC2-Instanz vom Typ `t3.micro` erstellt.

### Deployment

Starten mittels

    terraform init
    terraform apply -auto-approve

Die VM wird anschliessend in AWS erstellt.

### Testen

Nach dem Deployment kann die Instanz in der AWS Console unter EC2 geprüft werden.

Falls passende zusätzliche Ressourcen vorhanden sind, etwa eine Security Group und ein Key Pair, kann auch ein Login per SSH erfolgen.

Beispiel für die Anzeige der laufenden Instanz:

    aws ec2 describe-instances \
      --filters "Name=tag:Name,Values=${TF_VAR_name_prefix}-vm" \
      --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,Type:InstanceType}' \
      --output table

### Wichtige Punkte

* EC2 ist eine klassische VM und nicht serverlos
* Im Unterschied zu S3, DynamoDB oder Lambda läuft die Instanz dauerhaft, bis sie gestoppt oder gelöscht wird
* `t3.micro` ist ein kleiner Instanztyp und eignet sich gut für einfache Tests
* Das verwendete Ubuntu-Image wird über die AMI-Datenquelle bestimmt
* Der Name der VM wird über das Tag `Name = "<prefix>-vm"` gesetzt

### Verhalten der Ressourcen

Es wird genau eine EC2-Instanz erstellt. Das Image kommt aus einer AMI-Datenquelle, wodurch nicht eine feste AMI-ID im Code stehen muss. So kann ein passendes Ubuntu-Image dynamisch ermittelt werden.

Zusätzlich werden allgemeine Tags übernommen und um ein `Name`-Tag ergänzt. Dadurch ist die Instanz in der AWS Console und per CLI einfacher auffindbar.

#