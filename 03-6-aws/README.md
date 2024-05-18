## Übung 03-66: AWS und Terraform

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [AWS CLI](https://aws.amazon.com/de/cli/) installiert sein.

### Übung

Implementiert den [Webshop](../03-3-azure/) in der AWS Cloud mittels Terraform.

Starten mittels

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