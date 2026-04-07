## Übung 03-6: Azure - Einfache VM mit Virtual Machine

### Übung

Dieses Beispiel zeigt eine minimal gestartete virtuelle Maschine auf Azure mit Terraform/OpenTofu. Die VM wird als Azure Linux Virtual Machine erstellt und eignet sich für einfache Tests, Login-Übungen oder grundlegende Serveraufgaben.

* Verständnis für virtuelle Maschinen in Azure
* Starten einer Linux-VM mit einem Ubuntu-Image
* Arbeiten mit einer klassischen Compute-Ressource statt serverlosen Diensten

### Architektur

* **Resource Group**: stellt die bestehende Ressourcengruppe bereit, in der alle Ressourcen angelegt werden
* **Virtual Network**: definiert das virtuelle Netzwerk
* **Subnet**: stellt das Subnetz innerhalb des virtuellen Netzwerks bereit
* **Network Security Group**: dient zur Steuerung des Netzwerkverkehrs
* **Public IP**: weist der VM eine öffentliche IP-Adresse zu
* **Network Interface**: verbindet die VM mit dem Subnetz und der öffentlichen IP
* **Linux Virtual Machine**: stellt die virtuelle Maschine bereit
* **Source Image Reference**: definiert das verwendete Ubuntu-Image
* **VM Size**: bestimmt CPU- und RAM-Ausstattung der VM

In diesem Beispiel wird eine einzelne Linux-VM der Grösse `Standard_B1s` erstellt.

### Deployment

Starten mittels

    terraform init
    terraform apply -auto-approve

Die VM wird anschliessend in Azure erstellt.

### Testen

Nach dem Deployment kann die Instanz im Azure Portal bei den Virtual Machines geprüft werden.

Da in diesem Beispiel eine öffentliche IP-Adresse konfiguriert ist und die Passwort-Authentifizierung aktiviert wurde, ist grundsätzlich auch ein Login auf die VM möglich, sofern passende Regeln in der Network Security Group vorhanden sind.

Beispiel für die Anzeige der laufenden VM:

    az vm show \
      --resource-group ${TF_VAR_name_prefix}-rg \
      --name ${TF_VAR_name_prefix}-vm \
      --show-details \
      --output table
