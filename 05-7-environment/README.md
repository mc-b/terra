## Environments (Umgebungen)

### Einleitung

In modernen Infrastrukturprojekten ist die Trennung zwischen Entwicklungs-, Test- und Produktionsumgebungen essenziell, um Stabilität, Skalierbarkeit und Sicherheit zu gewährleisten. Terraform bietet dafür zwei leistungsstarke Mechanismen:

1. **Workspaces:** Terraform Workspaces ermöglichen es, denselben Code für mehrere Zustände (`state files`) zu verwenden. Dies ist besonders praktisch, wenn Infrastrukturkonfigurationen zwischen Umgebungen wie `dev`, `test` und `prod` ähnlich sind, sich jedoch in Details wie Netzwerkbereichen, Rechenressourcen oder Skalierungsparametern unterscheiden.

2. **tfvars:** Mit `.tfvars`-Dateien können spezifische Variablenwerte für jede Umgebung definiert werden. Diese Dateien enthalten Werte wie IP-Bereiche, Instanztypen oder Skalierungsfaktoren, die an die jeweilige Umgebung angepasst sind.

Die Kombination dieser beiden Funktionen ermöglicht eine flexible, skalierbare und leicht wartbare Infrastrukturverwaltung.

---

### Nutzung der Umgebungen `prod`, `dev` und `test`

Jede Umgebung (`prod`, `dev`, `test`) hat ihre eigene `.tfvars`-Datei, die spezifische Werte für die jeweilige Umgebung definiert. Die Workspaces sorgen dafür, dass Terraform für jede Umgebung separate Zustandsdateien verwaltet.

#### **Beispielkonfiguration:**

**`environments/dev/dev.tfvars`:**
* Enthält Variablen für die Entwicklungsumgebung (z. B. kleinere Instanzen, weniger Replikate).

**`environments/test/test.tfvars`:**
* Definiert Variablen für die Testumgebung (ähnlich wie `prod`, aber mit isoliertem Netzwerk).

**`environments/prod/prod.tfvars`:**
* Enthält Werte für die Produktionsumgebung (z. B. Hochverfügbarkeit, große Ressourcen).

---

### Befehle für die Verwaltung der Umgebungen

#### 1. **Entwicklungsumgebung (dev)**

    terraform workspace new dev
    terraform plan -var-file="environments/dev/dev.tfvars"
    terraform apply -var-file="environments/dev/dev.tfvars" -auto-approve
    terraform destroy -var-file="environments/dev/dev.tfvars" -auto-approve

- **`terraform workspace new dev`:** Erstellt einen neuen Workspace für die Entwicklungsumgebung.
- **`plan`:** Zeigt die geplanten Änderungen für die Entwicklungsumgebung an.
- **`apply`:** Führt die Änderungen durch und erstellt die Ressourcen basierend auf den Werten in `dev.tfvars`.
- **`destroy`:** Entfernt alle Ressourcen der Entwicklungsumgebung.

#### 2. **Testumgebung (test)**

    terraform workspace new test
    terraform plan -var-file="environments/test/test.tfvars"
    terraform apply -var-file="environments/test/test.tfvars" -auto-approve
    terraform destroy -var-file="environments/test/test.tfvars" -auto-approve

- Ähnlich wie bei `dev`, jedoch mit Werten aus `test.tfvars`.

#### 3. **Produktionsumgebung (prod)**

    terraform workspace new prod
    terraform plan -var-file="environments/prod/prod.tfvars"
    terraform apply -var-file="environments/prod/prod.tfvars" -auto-approve
    terraform destroy -var-file="environments/prod/prod.tfvars" -auto-approve

- Führt die gleichen Schritte für die Produktionsumgebung aus, wobei grosse Ressourcen und Hochverfügbarkeitsanforderungen in `prod.tfvars` definiert werden können.

---

### Vorteile der Kombination aus Workspaces und tfvars

1. **Konsistenz:** Dieselbe Terraform-Konfiguration (`main.tf`) kann für alle Umgebungen verwendet werden, wodurch Redundanz vermieden wird.
2. **Trennung der Zustände:** Workspaces stellen sicher, dass die Zustandsdateien (`terraform.tfstate`) jeder Umgebung unabhängig sind.
3. **Flexibilität:** Änderungen können isoliert getestet und schrittweise von `dev` über `test` nach `prod` übertragen werden.
4. **Einfachheit:** Die Nutzung von `.tfvars` macht das Verwalten umgebungsspezifischer Werte intuitiv und leicht skalierbar.

Mit dieser Strategie können Sie sicherstellen, dass jede Umgebung isoliert bleibt und gleichzeitig mit einem zentralisierten Terraform-Workflow gesteuert wird.