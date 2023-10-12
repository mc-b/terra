## Übung 6: AWS und Terraform

Für die Übung sind die CLI für AWS und Terraform zu installieren.

* [AWS CLI](https://aws.amazon.com/de/cli/)
* [Terraform Installation](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)

### Vorgehen

Implementiert den [Webshop](../03-2-azure/) in der AWS Cloud mittels Terraform.

Starten mittels

    cd 03-6-aws

    aws configure
        AWS Access Key ID [****************....]:
        AWS Secret Access Key [****************....]:
        Default region name [us-west-2]: us-east-1
        Default output format [None]:  

    terraform init
    terraform apply -auto-approve

Nach dem erstellen der Ressourcen, wird die URL der VM mit dem Reverse Proxy und dem Menu, zum Anwählen, der anderen VMs angezeigt.

Vorher muss aber die Datei `/etc/host` in der Reverse Proxy VM so angepasst werden. Um dort die Namen und IP-Adressen der VMs `order`, `customer` und `catalog` zu erfassen.
Sollte auch mit einer Private Route 53 Zone möglich sein, die Terraform Einträge sind jedoch nicht klar.

**Links**

* [Basic Two-Tier AWS Architecture](https://github.com/hashicorp/terraform-provider-aws/tree/main/examples/two-tier)
* [Umfangreicheres Beispiel mit VPC, NAT etc.](https://github.com/hashicorp/learn-terraform-modules-create)