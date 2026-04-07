## Übung 03-1: Azure CLI

Das Azure CLI (Command Line Interface) ermöglicht es, Azure-Dienste direkt über die Kommandozeile zu steuern. Damit kannst du Ressourcen wie Storage Accounts, Virtual Machines oder Cosmos DB ohne Weboberfläche erstellen, verwalten und automatisieren.

Wir verwenden das Azure CLI, um erste Ressourcen in der Azure Cloud manuell zu erstellen. Diese werden anschliessend analysiert und in Terraform-Code überführt, damit sie reproduzierbar und automatisiert verwaltet werden können.

### Übung Blog Speicher und Table einrichten

Erstellung eines Storage Accounts sowie Aktivierung einer statischen Website mittels Azure CLI.

Voraussetzung: Resource Group existiert.

Beispiel:

    export NAME=$(echo "${TF_VAR_name_prefix}sa" | tr -d '-' | tr '[:upper:]' '[:lower:]' | cut -c1-24)
  
    az storage account create \
      --name $NAME \
      --resource-group ${TF_VAR_name_prefix}-rg \
      --location "Switzerland North" \
      --sku Standard_LRS \
      --kind StorageV2 \
      --tags Owner=${TF_VAR_name_prefix} Course=terra
  
    az storage blob service-properties update \
      --account-name $NAME \
      --static-website \
      --index-document index.html \
      --404-document error.html \
      --auth-mode login
      
    az storage table create \
      --name exampletable \
      --account-name $NAME \
      --auth-mode login      

**Hinweise**:

* `Standard_LRS` entspricht `Standard` + `LRS`
* Name: nur Kleinbuchstaben und Zahlen, 3–24 Zeichen
* Name muss **global eindeutig** sein (über ganz Azure)
* Container `$web` wird automatisch erstellt

Was ist der `$web` Container:
* `$web` ist ein spezieller Blob-Container für **Static Website Hosting**
* wird automatisch erstellt, sobald du `--static-website` aktivierst
* enthält deine Website-Dateien (`index.html`, `error.html`, etc.)
* ist öffentlich lesbar (nur für Webzugriff)

**Webseiten hochladen**

    az storage blob upload \
      --account-name $NAME \
      --container-name '$web' \
      --name index.html \
      --file site/index.html \
      --auth-mode login
  
    az storage blob upload \
      --account-name $NAME \
      --container-name '$web' \
      --name error.html \
      --file site/error.html \
      --auth-mode login

**Webseiten anzeigen**

Angezeigten URL im Browser öffnen

    az storage account show --name $NAME --query "primaryEndpoints.web" --output tsv
    
**Kontrolle der angelegten Ressourcen**

Anzeige der erstellten Ressourcen via Azure CLI:

Resource Group:

    az resource list --resource-group ${TF_VAR_name_prefix}-rg --output table

Dateien im $web Container:

    az storage blob list --account-name $NAME --container-name '$web' --auth-mode login --output table

Tables:

    az storage table list --account-name $NAME --auth-mode login --output table

**Aufräumen**:

    az storage account delete \
      --name $NAME \
      --resource-group ${TF_VAR_name_prefix}-rg \
      --yes

### Übung virtuellen Maschinen (VMs) erstellen

Als Cloud-init Datei verwenden wir die gleiche YAML-Datei wie aus [Übung 1](../../01-iac/01-1-iac/cloud-init-nginx.yaml).

Mittels dieser Datei und dem jeweiligen Cloud CLI, erstellen wir eine neu VM.
 
Anschliessend müssen folgende Aktionen ausgeführt werden:
* Erstellen einer Ressource Gruppe, wo unsere VMs abgelegt werden:    
* Erstellen der VM 
* Freigeben des Ports 80, damit wir via Browser auf die VM bzw. die Installierten Services zugreifen können.

Die Befehle sind wie folgt:

    az group create --name ${TF_VAR_name_prefix} --location eastus2
    az vm create --resource-group ${TF_VAR_name_prefix} --name myvm --image Ubuntu2204 --size Standard_B1ls --location eastus2 --custom-data cloud-init.yaml --generate-ssh-keys --public-ip-sku Standard --admin-username myuser
    az vm open-port --port 80 --resource-group ${TF_VAR_name_prefix} --name myvm
    
Die Ausgabe ist ungefähr wie folgt:

    {
    "fqdns": "",
    "id": "/subscriptions/.../resourceGroups/${TF_VAR_name_prefix}/providers/Microsoft.Compute/virtualMachines/myvm",
    "location": "eastus2",
    "macAddress": "...",
    "powerState": "VM running",
    "privateIpAddress": "10.0.0.4",
    "publicIpAddress": "...",
    "resourceGroup": "${TF_VAR_name_prefix}",
    "zones": ""
    }

**Hinweis**: Sollte beim Erstellen der VM eine Fehlermeldung wegen zu wenig Public IP-Adressen kommen, kann auf die Public-IP verzichtet werden.

    az network vnet create --resource-group ${TF_VAR_name_prefix} --name myVnet --subnet-name mySubnet --location eastus2
    az network nic create --resource-group ${TF_VAR_name_prefix} --name myNic --vnet-name myVnet --subnet mySubnet
    az vm create --resource-group ${TF_VAR_name_prefix} --name myvm --image Ubuntu2204 --size Standard_B1ls --location eastus2 --custom-data cloud-init.yaml --generate-ssh-keys --nics myNic --admin-username myuser

Dazu müssen wir die Netzwerke manuell erstellen und dann die VM damit verbinden.
    
**Überprüft das Ergebnis, durch Anwählen der Public IP-Adresse Eurer VM im Browser.**

Die erstellten Ressourcen können auch via Microsoft Azure [Portal](https://portal.azure.com/) angeschaut werden.

Sucht, im Portal, zuerst nach `Resource Group` und navigiert dann in die `Resource Group` - `${TF_VAR_name_prefix}`

Um die VM zu löschen, genügt es, die Resource Gruppe zu löschen.    

    az group delete --name ${TF_VAR_name_prefix} --yes 
    
### Links

* [Schritt für Schritt Anleitung](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)           
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
