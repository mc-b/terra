## Stages - Environments

Eine Kombination aus Stages und Environments (z. B. prod, dev, test) könnte dann wie folgt aussehen:

    terraform/
    ├── 01-stage-infrastructure/
    │   ├── environments/
    │   │   ├── dev/
    │   │   │   ├── terraform.tfvars
    │   │   ├── test/
    │   │   │   ├── terraform.tfvars
    │   │   ├── prod/
    │   │       ├── terraform.tfvars
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── providers.tf
    ├── 02-stage-application/
    │   ├── environments/
    │   │   ├── dev/
    │   │   │   ├── terraform.tfvars
    │   │   ├── test/
    │   │   │   ├── terraform.tfvars
    │   │   ├── prod/
    │   │       ├── terraform.tfvars
    │   ├── data.tf
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── providers.tf