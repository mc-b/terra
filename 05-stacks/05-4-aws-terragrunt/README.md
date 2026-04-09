## Übung 05-4: AWS - Terragrunt

Für verschiedene Umgebungen wie `dev`, `test`, `prod` verwenden wir das neu strukturierte Beispiel 05-2-aws-env und erweitern es um `terragrunt`.

    /
    ├── dev/
    │   ├── terragrunt.hcl
    ├── test/
    │   ├── terragrunt.hcl
    └── prod/
        ├── terragrunt.hcl
    ../05-2-aws-env/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
    
### Übung

Erstellt folgende Dateien

`dev/terragrunt.hcl`

    terraform {
      source = "../../05-2-aws-env"
    }
    
    inputs = {
      environment = "dev"
    }
    
`test/terragrunt.hcl`

    terraform {
      source = "../../05-2-aws-env"
    }
    
    inputs = {
      environment = "test"
    }

`prod/terragrunt.hcl`

    terraform {
      source = "../../05-2-aws-env"
    }
    
    inputs = {
      environment = "prod"
    }

### Deployment

Dev Umgebung deployen    
    
    cd dev
    terragrunt init    
    terragrunt apply -auto-approve 
    
Test Umgebung deployen
    
    cd ../test
    terragrunt init 
    terragrunt apply -auto-approve 
    
Produktions Umgebung deployen
    
    cd ../prod
    terragrunt init     
    terragrunt apply -auto-approve 
    
### Aufräumen

    terragrunt destroy -auto-approve
    cd ../test
    terragrunt destroy -auto-approve
    cd ../dev    
    terragrunt destroy -auto-approve
    