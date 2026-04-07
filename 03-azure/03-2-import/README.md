## Übung 03-2: Azure - Terraform Import

### Übung 

In dieser Übung wollen wir die erstellten Azure Ressourcen aus [Übung 1](../03-1-cli/README.md) nach Terraform überführen.

Diese Arbeiten müssen in der **PowerShell** ausgeführt werden, weil Git/Bash mit `/sub...` nicht klar kommt.

Dazu verwenden wir die neue Import-Variante von Terraform.

Initialisierung des Providers

    terraform init    

Terraform kann bestehende Ressourcen nicht nur importieren, sondern auch die passende Konfiguration automatisch generieren.

Dazu werden Import-Blöcke definiert, und Terraform erstellt daraus eine fertige main.tf.

Erstelle zuerst eine Datei import.tf:

    import {
      to = azurerm_storage_account.example
      id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"
    }
    
    import {
      to = azurerm_storage_account_static_website.example
      id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"
    }
    
    import {
      to = azurerm_storage_table.example
      id = "https://<storage-account-name>.table.core.windows.net/studenttable"
    }

Mittels `terraform plan` können die entsprechenden Terraform Deklaration automatisch erstellt werden:

    terraform plan -generate-config-out main.tf

Terraform analysiert die bestehenden Ressourcen und erstellt automatisch eine Konfigurationsdatei (main.tf).

Diese Datei enthält die notwendigen Attribute, um die Ressourcen vollständig mit Terraform zu verwalten.    

**Hinweis**

Die generierte Konfiguration ist oft sehr detailliert und enthält auch Werte, die du normalerweise nicht selbst definieren würdest. Ziel ist es, die Datei zu vereinfachen und an deine bestehende Struktur anzupassen.

### Übung (virtuelle Maschinen)

In dieser Übung wollen wir die erstellten Azure Ressourcen aus [Übung 1](../03-1-cli/README.md) nach Terraform überführen.

Diese Arbeiten müssen in der **PowerShell** ausgeführt werden, weil Git/Bash mit `/sub...` nicht klar kommt.

Gibt alle erstellen Ressourcen zur Ressource Gruppe aus, ersetzt `mygroup` durch die Ausgabe von `$env:TF_VAR_name_prefix`

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
