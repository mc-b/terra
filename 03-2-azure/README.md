## Übung 03-2: Azure - Terraform Import

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) installiert sein.

### Übung

In dieser Übung wollen wir die erstellten Azure Ressourcen aus [Übung 1](../03-1-azure/) nach Terraform überführen.

Diese Arbeiten müssen in der **PowerShell** ausgeführt werden, weil Git/Bash mit `/sub...` nicht klar kommt.

Erstellen einer Datei `provider.tf`, für den Azure Provider, mit folgenden Inhalt    

    provider "azurerm" {
      features {}
    }
    
Initialisierung des Providers

    terraform init    

Anmelden an der Azure Cloud 

    az login
    
### Ressource Gruppe

Um die Ressource Gruppe zu importieren, brauchen wir deren `id`. Deshalb zeigen wir mit dem Azure CLI zuerst deren Informationen an:

    az group list
    
Die Ausgabe sieht in etwa so aus:

    {
      "id": "/subscriptions/.../resourceGroups/mygroup",
      "location": "eastus2",
      "name": "mygroup",
      "type": "Microsoft.Resources/resourceGroups"
    }
    
Mit der `id` können wir die Gruppe importieren. **...** durch Eure Subscriptions-Id ersetzen. 

    terraform import azurerm_resource_group.mygroup /subscriptions/.../resourceGroups/mygroup
    
Die erstelle Terraform Deklaration können wir wie folgt anzeigen:

    terraform state show azurerm_resource_group.mygroup
    

### Virtuelle Maschine

    az vm list
    
Die Ausgabe sieht in etwa so aus:

    [
      {
        "hardwareProfile": {
          "vmSize": "Standard_D2_v4",
        },
        "id": "/subscriptions/.../resourceGroups/MYGROUP/providers/Microsoft.Compute/virtualMachines/myvm",
       
Import 

    terraform import azurerm_linux_virtual_machine.myvm /subscriptions/.../resourceGroups/MYGROUP/providers/Microsoft.Compute/virtualMachines/myvm  
    
Deklaration

    terraform state show azurerm_linux_virtual_machine.myvm         
        
#### Restliche Ressourcen

Für die restlichen Ressourcen wie
- Netzwerk
- Firewall
etc. bleibt das Vorgehen gleich.

Die benötigten Metadaten sind in `main.tf` zu überführen, variable Werte durch Variablen `variables.tf` ersetzen und mit den bekannten Terraform Befehlen testen.

### Variante 2 - Experimentell

Gibt alle erstellen Ressourcen zur Ressource Gruppe aus:

    az resource list --query "[?resourceGroup=='mygroup'].{ id: id, name: name, flavor: kind, resourceType: type, region: location }"
    
Die Ausgabe sieht in etwa so aus:

    [
      {
        "id": "/subscriptions/.../resourceGroups/mygroup/providers/Microsoft.Network/publicIPAddresses/myvmPublicIP",
        "name": "myvmPublicIP",
        "resourceType": "Microsoft.Network/publicIPAddresses"
      },
      {
        "id": "/subscriptions/.../resourceGroups/mygroup/providers/Microsoft.Network/networkSecurityGroups/myvmNSG",
        "name": "myvmNSG",
        "resourceType": "Microsoft.Network/networkSecurityGroups"
      },
      {
        "id": "/subscriptions/.../resourceGroups/mygroup/providers/Microsoft.Network/virtualNetworks/myvmVNET",
        "name": "myvmVNET",
        "resourceType": "Microsoft.Network/virtualNetworks"
      },
      {
        "id": "/subscriptions/.../resourceGroups/mygroup/providers/Microsoft.Network/networkInterfaces/myvmVMNic",
        "name": "myvmVMNic",
        "resourceType": "Microsoft.Network/networkInterfaces"
      },
      {
        "id": "/subscriptions/.../resourceGroups/mygroup/providers/Microsoft.Compute/virtualMachines/myvm",
        "name": "myvm",
        "resourceType": "Microsoft.Compute/virtualMachines"
      }
    ]
    

Erstellt eine Datei `import.tf` und fügt alle zu Importierenden Ressourcen, im nachfolgenden Format, in die Datei ein (`...` durch `subscription-id` ersetzen):

    import {
        to = azurerm_resource_group.main
        id  = "/subscriptions/.../resourceGroups/mygroup"
    }
    import {
        to  = azurerm_public_ip.main  
        id  = "/subscriptions/.../resourceGroups/mygroup/providers/Microsoft.Network/publicIPAddresses/myvmPublicIP"
    }
    import {
        to  = azurerm_network_security_group.main  
        id  = "/subscriptions/.../resourceGroups/mygroup/providers/Microsoft.Network/networkSecurityGroups/myvmNSG"
    }
    import {
        to  = azurerm_virtual_network.main  
        id  = "/subscriptions/.../resourceGroups/mygroup/providers/Microsoft.Network/virtualNetworks/myvmVNET"
    }
    import {
        to  = azurerm_network_interface.main  
        id  = "/subscriptions/.../resourceGroups/mygroup/providers/Microsoft.Network/networkInterfaces/myvmVMNic"
    }
    import {
        to  = azurerm_linux_virtual_machine.main  
        id  = "/subscriptions/.../resourceGroups/MYGROUP/providers/Microsoft.Compute/virtualMachines/myvm"
    }

Mittels `terraform plan` können die entsprechenden Terraform Deklaration automatisch erstellt werden:

    terraform plan -generate-config-out main.tf
 
### Links

* [Schritt für Schritt Anleitung](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)           
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
* [Offizielle Cloud-init Beispiele](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
* [Neue Import Variante](https://www.youtube.com/watch?v=znfh_00EDZ0&ab_channel=NedintheCloud)
