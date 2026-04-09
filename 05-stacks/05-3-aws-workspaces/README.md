##  Übung 05-3 AWS Workspaces

Für verschiedene Umgebungen wie `dev`, `test`, `prod` strukturieren wir das Beispiel 03-3-web neu.

├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
└── environments
    ├── dev
    │   ├── index.html
    │   └── error.html
    ├── test
    │   ├── index.html
    │   └── error.html
    └── prod
        ├── index.html
        └── error.html
        
Die `*.html` Dateien entfernen wir aus Terraform und legen sie separat ab.     

Die Unterscheidung nach `dev`, `test`, `prod` lösen wir mittels Workspaces.  

### Übung

Ändert/Erweitert folgende Dateien

`variables.tf` ergänzt `html_path`. Wir verwenden neu `terraform.workspace` welches auf den aktuellen Workspace zeigt.

    locals {
      bucket_name = "${var.name_prefix}-${data.aws_caller_identity.current.account_id}-${terraform.workspace}"
      html_path   = "${path.module}/environments/${terraform.workspace}"
    }

### Deployment

Starten mittels

    terraform init
    
Dev Umgebung deployen    
    
    terraform workspace new dev    
    terraform apply -auto-approve
    
Test Umgebung deployen
    
    terraform workspace new test     
    terraform apply -auto-approve 
    
Produktions Umgebung deployen
    
    terraform workspace new prod    
    terraform apply -auto-approve 

Die Website-URL kann danach über einen Output oder direkt im AWS S3 Website Endpoint aufgerufen werden.

### Aufräumen

    terraform workspace select dev
    terraform destroy -auto-approve 
    
    terraform workspace select test
    terraform destroy -auto-approve 
    
    terraform workspace select prod
    terraform destroy -auto-approve         



