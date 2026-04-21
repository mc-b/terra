## Übung 03-3: Azure – Statische Website mit Storage Account

### Übung

Dieses Beispiel zeigt eine einfache statische Website auf Microsoft Azure mit Terraform/OpenTofu. Die Website wird direkt aus einem Storage Account ausgeliefert. Es werden keine VMs, Container oder serverlosen Funktionen benötigt.

* Verständnis für statische Websites auf Azure Storage
* Umgang mit öffentlich zugänglichen Inhalten
* Minimaler Webauftritt ohne zusätzliche Infrastruktur

### Architektur

* **Storage Account**: speichert die Website-Dateien
* **Static Website Feature**: aktiviert Webhosting im Storage Account
* **$web Container**: enthält die Website-Dateien (wird automatisch erstellt)

Die Website ist anschliessend über eine URL wie diese erreichbar:

    https://<storage-account-name>.z1.web.core.windows.net

### Enthaltene Dateien

Die Dateien werden im Container **$web** gespeichert:

Die Dateien müssen entweder separat via Terraform (z.B. `azurerm_storage_blob`) oder CLI hochgeladen werden.

### Deployment

Starten mittels:

    terraform init
    terraform apply -auto-approve

Nach erfolgreichem Deployment ist die statische Website aktiviert.
    
### Webseiten mittels Terraform hochladen

Erstellt eine neue Datei `web.tf` mit folgendem Inhalt

    resource "azurerm_storage_blob" "website_files" {
      for_each = {
        "index.html" = "../03-1-cli/site/index.html"
        "error.html" = "../03-1-cli/site/error.html"
      }
    
      name                   = each.key
      storage_account_name   = azurerm_storage_account.green.name
      storage_container_name = "$web"
      type                   = "Block"
      source                 = each.value
      content_type           = "text/html"
    
      depends_on = [
        azurerm_storage_account_static_website.green
      ]
    } 
    
Und führt `terraform apply -auto-approve` nochmals aus.

Die Website kann direkt im Browser geöffnet werden:

    NAME=$(echo ${TF_VAR_name_prefix} | tr -d '-')
    az storage account show --name ${NAME}green --query "primaryEndpoints.web" --output tsv

**Hinweis** warum zwei Schritte:

Azure meldet die Static-Website-Konfiguration als erstellt, bevor der `$web`-Container auf der Blob/Data-Plane vollständig verfügbar ist. Dadurch entsteht eine Race Condition, bei der Uploads im gleichen Terraform-Run sporadisch fehlschlagen. Stabil funktioniert es, wenn Provisionierung und Datei-Upload in zwei getrennten Schritten erfolgen.


### Wichtige Punkte

* Der Container **$web** wird automatisch erstellt, sobald das Static Website Feature aktiviert wird
* Dateien müssen explizit hochgeladen werden – Terraform macht das nicht automatisch ohne zusätzliche Ressourcen
* Inhalte im **$web** Container sind öffentlich lesbar
* Es handelt sich um eine rein statische Website ohne Backend-Logik
* Änderungen an Dateien erfordern ein erneutes Hochladen (Terraform oder CLI)

### Verhalten der Ressourcen

Der Storage Account wird erstellt und mit Tags versehen. Danach wird das Static Website Feature aktiviert:

* `index.html` als Startseite
* `error.html` als Fehlerseite

Azure erstellt dabei automatisch den Container **$web**, in dem die Website-Dateien liegen. Ohne hochgeladene Dateien bleibt die Website leer bzw. liefert Fehler.
