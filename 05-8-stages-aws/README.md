## Stages

Eine Trennung nach Stages wie `01-stage-infrastructure` (Infrastruktur wie Netzwerke, Subnetze, Sicherheitsgruppen) und `02-stage-application` (Applikationen oder instanzspezifische Ressourcen) ist eine gängige Praxis, um die Komplexität zu reduzieren und eine modulare Infrastrukturverwaltung zu ermöglichen.

### Vorteile der Trennung nach Stages

1. **Klarheit:** Jede Stage hat eine klar definierte Aufgabe, was die Übersichtlichkeit verbessert.
2. **Wiederverwendbarkeit:** Die Infrastruktur kann unabhängig von der Applikation angepasst werden.
3. **Stabilität:** Änderungen in einer Stage (z. B. Netzwerk) wirken sich nicht direkt auf die andere (z. B. Applikationen) aus.
4. **Parallele Entwicklung:** Teams können unabhängig an verschiedenen Stages arbeiten.

---

### Projektstruktur für Stages

    terraform/
    ├── 01-stage-infrastructure/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── providers.tf
    ├── 02-stage-application/
    │   ├── data.tf
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── providers.tf

---

### Abhängigkeit zwischen Stages

Die Ausgabe von `01-stage-infrastructure` (Infrastruktur wie Netzwerke, Subnetze, Sicherheitsgruppen) wird als Eingabe für `02-stage-application` (Applikationen oder instanzspezifische Ressourcen) verwendet. 

Dazu muss im ersten Stage die benötigten Werte als Outputs definiert werden:

**Beispiel**: `01-stage-infrastructure/output.tf`

    output "intern_security_group_id" {
      description = "ID of the internal security group created by the security module"
      value       = module.security.intern_security_group_id
    }
    
    output "intern_subnet_id" {
      description = "ID of the internal subnet created by the network module"
      value       = module.network.intern_subnet_id
    }

Um diese anschliessend in den zweiten Stage zu importieren:

**Beispiel**: `02-stage-application/data.tf` mit Local State

    data "terraform_remote_state" "infrastructure" {
      backend = "local"
    
      config = {
        path = "../01-stage-infrastructure/terraform.tfstate"
      }
    }

### Workflow

#### 1. `01-stage-infrastructure`: Infrastruktur bereitstellen

    cd 01-stage-infrastructure
    terraform init
    terraform apply -auto-approve

#### `02-stage-application`: Applikationen bereitstellen

    cd 02-stage-application
    terraform init
    terraform apply -auto-approve

#### 3. Zerstören der Ressourcen in umgekehrter Reihenfolge

    cd 02-stage-application
    terraform destroy -auto-approve

    cd ../01-stage-infrastructure
    terraform destroy -auto-approve

### Fazit

Die Trennung nach Stages bietet eine klare Struktur und ermöglicht es, Infrastruktur und Anwendungen unabhängig voneinander zu verwalten. Mithilfe von Outputs und Remote State lassen sich Abhängigkeiten zwischen Stages elegant lösen, ohne die Konfiguration unnötig zu vermischen.