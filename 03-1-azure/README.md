## Übung 03-1: Azure CLI

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) installiert sein.

### Übung

Als Cloud-init Datei verwenden wir die gleiche YAML-Datei wie aus [Übung 1](../01-1-iac/cloud-init-nginx.yaml).

Mittels dieser Datei und dem jeweiligen Cloud CLI, erstellen wir eine neu VM.

Anmelden an der Azure Cloud 

    az login
 
Anschliessend müssen folgende Aktionen ausgeführt werden:
* Erstellen einer Ressource Gruppe, wo unsere VMs abgelegt werden:    
* Erstellen der VM 
* Freigeben des Ports 80, damit wir via Browser auf die VM bzw. die Installierten Services zugreifen können.

Die Befehle sind wie folgt:

    az group create --name mygroup --location switzerlandnorth
    az vm create --resource-group mygroup --name myvm --image Ubuntu2204 --size Standard_B1ls --location switzerlandnorth --custom-data cloud-init.yaml --generate-ssh-keys --public-ip-sku Standard --admin-username myuser
    az vm open-port --port 80 --resource-group mygroup --name myvm
    
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

**Hinweis**: Sollte beim Erstellen der VM eine Fehlermeldung wegen zu wenig Public IP-Adressen kommen, kann auf die Public-IP verzichtet werden.

    az network vnet create --resource-group mygroup --name myVnet --subnet-name mySubnet --location switzerlandnorth
    az network nic create --resource-group mygroup --name myNic --vnet-name myVnet --subnet mySubnet
    az vm create --resource-group mygroup --name myvm --image Ubuntu2204 --size Standard_B1ls --location switzerlandnorth --custom-data cloud-init.yaml --generate-ssh-keys --nics myNic --admin-username myuser

Dazu müssen wir die Netzwerke manuell erstellen und dann die VM damit verbinden.
    
**Überprüft das Ergebnis, durch Anwählen der Public IP-Adresse Eurer VM im Browser.**

Die erstellten Ressourcen können auch via Microsoft Azure [Portal](https://portal.azure.com/) angeschaut werden.

Sucht, im Portal, zuerst nach `Resource Group` und navigiert dann in die `Resource Group` - `mygroup`

Um die VM zu löschen, genügt es, die Resource Gruppe zu löschen.    

    az group delete --name mygroup --yes 
    
### Links

* [Schritt für Schritt Anleitung](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)           
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
