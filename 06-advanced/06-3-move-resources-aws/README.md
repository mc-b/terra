## Übung 06-3: Move Resources - AWS

### Übung

Wechselt in das Verzeichnis [03-6-aws](../03-6-aws) und erstellt die Resourcen

    cd ../03-6-aws
    terraform init
    terraform apply -auto-approve
    
Kopiert die State Datei ins Verzeichnis [05-6-modules-aws](../05-6-modules-aws) und wechselt in dieses Verzeichnis

    cp terraform.tfstate ../05-6-modules-aws
    cd ../05-6-modules-aws
    
Initialsiert Terraform und überprüft welche Änderungen Terraform vornehmen will

    terraform init
    terraform plan
    
Der letzte  (und relevante) Teil sieht wie folgt aus:

    Plan: 10 to add, 0 to change, 11 to destroy.
    
Terraform will alle Ressourcen zuerst löschen und dann neu bauen, obgleich sich ja nur die Anordnung der `*.tf` Dateien geändert hat, bzw. eine Modularisierung stattgefunden hat.

Abhilfe schafft hier eine Datei `moved.tf` mit folgendem Inhalt:

    # Network
    moved {
      from = aws_vpc.webshop
      to   = module.network.aws_vpc.webshop
    }
    moved {
      from = aws_subnet.webshop_intern
      to   = module.network.aws_subnet.webshop_intern
    }
    # Routing
    moved {
      from = aws_internet_gateway.webshop
      to   = module.routing.aws_internet_gateway.webshop
    }
    moved {
      from = aws_route.internet_access
      to   = module.routing.aws_route.internet_access
    }
    moved {
      from = aws_instance.webshop
      to   = module.routing.aws_instance.webshop
    }
    # Security
    moved {
      from = aws_security_group.webshop_intern
      to   = module.security.aws_security_group.webshop_intern
    }
    moved {
      from = aws_security_group.webshop
      to   = module.security.aws_security_group.webshop
    }
    # Application
    moved {
      from = aws_instance.catalog
      to   = module.application_catalog.aws_instance.catalog
    }
    moved {
      from = aws_instance.customer
      to   = module.application_customer.aws_instance.customer
    }
    moved {
      from = aws_instance.order
      to   = module.application_order.aws_instance.order
    } 
    
Erstellt diese und führt `terraform plan` nochmals aus.

    Plan: 0 to add, 1 to change, 1 to destroy. 
    
Jetzt wird nur noch die Ressource `aws_route_table_association` als überflüssig erkannt.                  