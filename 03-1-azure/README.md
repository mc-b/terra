## Übung 1: Azure CLI

Als Cloud-init Datei verwenden wir die gleiche YAML-Datei wie aus [Übung 1](../01-1-iac/cloud-init-nginx.yaml).

Mittels dieser Datei und dem jeweiligen Cloud CLI, erstellen wir eine neu VM.

### Vorgehen

Wechsel in das Arbeitsverzeichnis

    cd 03-1-azure

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
    
### Links

* [Schritt für Schritt Anleitung](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)           
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
