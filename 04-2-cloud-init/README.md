## Übung 04-2: Cloud Meta-Data

Die Übungen finden in der [Git/Bash](https://git-scm.com/downloads) statt. 

Ausserdem muss das Produkt [Multipass](https://multipass.run/) installiert sein.

Öffnet die Git/Bash Umgebung oder VSCode und dort ein Terminal. Wechselt ins Arbeitsverzeichnis der Übung:

    cd 04-2-cloud-init
    
### Multipass

    multipass launch --name metadata --cloud-init cloud-init.yaml
    
Nach erfolgter Installation öffnet einen Browser und wählt [http://metadata.mshome.net](http://metadata.mshome.net) an.       

### Azure Cloud

Anmelden an der Azure Cloud 

    az login
    
Anschliessend müssen folgende Aktionen ausgeführt werden:
* Erstellen einer Ressource Gruppe, wo unsere VMs abgelegt werden:    
* Erstellen der VM 
* Freigeben des Ports 80, damit wir via Browser auf die VM bzw. die Installierten Services zugreifen können.

<pre>
az group create --name mygroup --location switzerlandnorth
az vm create --resource-group mygroup --name myvm --image Ubuntu2204 --size Standard_D2_v4 --location switzerlandnorth --custom-data cloud-init.yaml --generate-ssh-keys --public-ip-sku Standard
az vm open-port --port 80 --resource-group mygroup --name myvm
</pre>    

Die Ausgabe ist ungefähr wie folgt:

    {
    "fqdns": "",
    "id": "/subscriptions/.../resourceGroups/mygroup/providers/Microsoft.Compute/virtualMachines/myvm",
    "location": "switzerlandnorth",
    "macAddress": "...",
    "powerState": "VM running",
    "privateIpAddress": "10.0.0.4",
    "publicIpAddress": "...",
    "resourceGroup": "mygroup",
    "zones": ""
    }
    
**Überprüft das Ergebnis, durch Anwählen der Public IP-Adresse Eurer VM im Browser.**

Die erstellten Ressourcen können auch via Microsoft Azure [Portal](https://portal.azure.com/) angeschaut werden.

Um die VM zu löschen, genügt es, die Resource Gruppe zu löschen.    

    az group delete --name mygroup --yes    
    
### AWS Cloud    
    
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
    
**Überprüft das Ergebnis, durch Anwählen der IP-Adresse Eurer VM im Browser.**

Um die erstellten Ressourcen zu löschen, genügt es, die VM zu löschen:

    aws ec2 terminate-instances --instance-ids <InstanceId>
     
        
