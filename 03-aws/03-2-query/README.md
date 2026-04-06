## Übung 03-2: AWS - Terraform Search und Bulk Import

**Zum aktuellen Stand (April 2026) gilt:**

Unterstützte Ressourcen: Der AWS-Provider unterstützt derzeit nur eine kleine Auswahl an list-Ressourcen. Dazu gehören aws_instance, aws_iam_role und aws_cloudwatch_log_group.

### Übung Import 

In dieser Übung werden die in der vorherigen Übung erstellten AWS-Ressourcen nicht mehr manuell über einzelne Import-IDs übernommen, sondern mit der neuen Such- und Bulk-Import-Funktion von Terraform.

Terraform kann bestehende, noch nicht verwaltete Infrastruktur über Query-Dateien suchen. Diese Queries liegen in Dateien mit der Endung `.tfquery.hcl` und werden mit `terraform query` ausgeführt. Anschliessend kann Terraform daraus automatisch Konfiguration sowie `import`-Blöcke erzeugen, damit die Ressourcen in den Workspace übernommen werden. ([HashiCorp Developer][2])

Initialisierung des Providers

    terraform init

Terraform unterscheidet dabei neu zwischen zwei Schritten:

1. Ressourcen suchen
2. Konfiguration und Import-Blöcke generieren

Der grundsätzliche Ablauf ist laut HashiCorp:

* `list`-Blöcke definieren, um bestehende Ressourcen zu suchen
* daraus Konfiguration und `import`-Blöcke generieren
* die generierte Konfiguration übernehmen und mit `terraform apply` importieren ([HashiCorp Developer][1])

### Query-Datei erstellen

Erstelle zuerst eine Datei `search.tfquery.hcl`.

In dieser Datei werden `list`-Blöcke definiert. Ein `list`-Block beschreibt, nach welchem Ressourcentyp gesucht werden soll und welche Provider-Konfiguration dafür verwendet wird. Die genauen Argumente im `config`-Block sind provider-spezifisch. Aus diesem Grund muss geprüft werden, ob die gewünschten AWS-Ressourcentypen vom Provider für Bulk Search unterstützt werden. ([HashiCorp Developer][1])

Beispielstruktur:

    list "aws_s3_bucket" "buckets" {
      provider = provider.aws
    
      config {
        # provider-spezifische Suchparameter
      }
    }
    
    list "aws_dynamodb_table" "tables" {
      provider = provider.aws
    
      config {
        # provider-spezifische Suchparameter
      }
    }

### Suche ausführen

Führe anschliessend die Query-Datei aus:

    terraform query


Terraform lädt dabei alle `.tfquery.hcl`-Dateien im Root-Verzeichnis und sucht anhand der `list`-Blöcke nach bestehenden, noch nicht verwalteten Ressourcen. ([HashiCorp Developer][2])

### Konfiguration generieren

Sobald die gewünschten Ressourcen gefunden wurden, kann Terraform Konfiguration für den Import erzeugen.

Dazu wird wie bisher `terraform plan` mit `-generate-config-out` verwendet:

    terraform plan -generate-config-out=main.tf

Terraform schreibt dabei eine neue Datei, zum Beispiel `main.tf`, mit den passenden `resource`- und `import`-Blöcken. Der Pfad darf nicht auf eine bereits existierende Datei zeigen, sonst bricht Terraform mit einem Fehler ab. ([HashiCorp Developer][3])

### Import ausführen

Übernimm die benötigten Teile aus der generierten Datei in deine eigentliche Konfiguration und führe danach aus:

    terraform apply -auto-approve

Damit importiert Terraform die gefundenen Ressourcen in den State. HashiCorp beschreibt diesen Ablauf explizit als Search → Generate Configuration → Apply Import. ([HashiCorp Developer][1])

**Hinweis**

Die generierte Konfiguration ist oft sehr ausführlich. Sie enthält auch Attribute, die du in einer von Hand gepflegten Konfiguration meist nicht ausschreiben würdest.

Ziel ist daher weiterhin, die erzeugte Datei zu bereinigen und auf die tatsächlich relevanten Argumente zu reduzieren. Auch beim neuen Workflow gilt: Generierte Konfiguration ist ein guter Startpunkt, aber selten die endgültige Zielstruktur. ([HashiCorp Developer][3])

### Links

* Query-Dateien (`.tfquery.hcl`) und `terraform query` ([HashiCorp Developer][2])
* Bulk Import bestehender Ressourcen ([HashiCorp Developer][1])
* Generieren von Konfiguration mit `-generate-config-out` ([HashiCorp Developer][3])
* Import-Übersicht von Terraform ([HashiCorp Developer][5])

[1]: https://developer.hashicorp.com/terraform/language/v1.14.x/import/bulk "Import existing resources in bulk | Terraform | HashiCorp Developer"
[2]: https://developer.hashicorp.com/terraform/language/files/tfquery "Query files | Terraform | HashiCorp Developer"
[3]: https://developer.hashicorp.com/terraform/language/import/generating-configuration?utm_source=chatgpt.com "Import - Generating Configuration | Terraform"
[4]: https://developer.hashicorp.com/terraform/language/block/tfquery/list?utm_source=chatgpt.com "list block reference for `.tfquery.hcl` files | Terraform"
[5]: https://developer.hashicorp.com/terraform/language/import?utm_source=chatgpt.com "Import resources overview | Terraform"
