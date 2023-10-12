## Übung 1: Azure CLI

Als Cloud-init Datei verwenden wir die gleiche YAML-Datei wie aus [Übung 1](../01-1-iac/cloud-init-nginx.yaml).

Mittels dieser Datei und dem jeweiligen Cloud CLI, erstellen wir eine neu VM.

### Vorgehen

Anmelden an der Azure Cloud 

    az login
 
Anschliessend müssen folgende Aktionen ausgeführt werden:
* Erstellen einer Ressource Gruppe, wo unsere VMs abgelegt werden:    
* Erstellen der VM 
* Freigeben des Ports 80, damit wir via Browser auf die VM bzw. die Installierten Services zugreifen können.

<pre>
az group create --name mygroup --location switzerlandnorth
az vm create --resource-group mygroup --name myvm --image UbuntuLTS --size Standard_D2_v4 --location switzerlandnorth --custom-data cloud-init.yaml --generate-ssh-keys --public-ip-sku Standard
az vm open-port --port 80 --resource-group mygroup --name myvm
</pre>    
    
**Überprüft das Ergebnis, durch Anwählen der IP-Adresse Eurer VM im Browser.**

Um die VM zu löschen, genügt es, die Resource Gruppe zu löschen.    

    az group delete --name mygroup --yes 
    
### Links

* [Schritt für Schritt Anleitung](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)           
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
