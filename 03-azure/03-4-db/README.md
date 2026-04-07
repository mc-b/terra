## Übung 03-4: Azure – Einfache Datenbank mit Table Storage

### Übung

Dieses Beispiel zeigt eine minimal konfigurierte NoSQL-Datenbank auf Azure mit Terraform/OpenTofu. Verwendet wird Azure Table Storage als einfacher Key-Value Store ohne zusätzliche Infrastruktur.

* Verständnis für NoSQL-Datenbanken (Key-Value)
* Arbeiten mit Azure Table Storage
* Persistente Datenspeicherung ohne Serverbetrieb

### Architektur

* **Storage Account**: stellt die Storage-Plattform bereit
* **Table Storage**: speichert Daten als Key-Value Einträge

Azure Table Storage ist Teil des Storage Accounts und benötigt keine separate Instanz oder Skalierungskonfiguration.

Die Tabelle verwendet ein Schlüsselkonzept bestehend aus:

* **PartitionKey (String)**: Gruppierung von Einträgen
* **RowKey (String)**: eindeutiger Schlüssel innerhalb der Partition

Zusammen bilden sie den Primärschlüssel.

### Deployment

Starten mittels

    terraform init
    terraform apply -auto-approve

Die Tabelle wird anschliessend direkt im Storage Account erstellt.

### Testen

Eintrag erstellen:


    az storage entity insert \
      --only-show-errors \
      --account-name "$(terraform output -raw storage_account_name)" \
      --table-name "$(terraform output -raw storage_table_name)" \
      --entity PartitionKey=demo RowKey=1 message=hello

Eintrag lesen:

    az storage entity show \
      --only-show-errors \
      --account-name "$(terraform output -raw storage_account_name)" \
      --table-name "$(terraform output -raw storage_table_name)" \
      --partition-key demo \
      --row-key 1

### Wichtige Punkte

* Azure Table Storage ist vollständig serverlos – kein Betrieb, keine Skalierung notwendig
* Es gibt kein Kapazitätsmodell wie bei DynamoDB → Abrechnung erfolgt nutzungsbasiert (Storage + Transaktionen)
* Schemafrei: neben PartitionKey und RowKey können beliebige Attribute gespeichert werden
* Storage Account ist obligatorisch und dient als Container für Tables, Blobs etc.

### Verhalten der Ressourcen

Die Tabelle wird ohne feste Struktur erstellt. Jeder Eintrag muss:

* **PartitionKey**
* **RowKey**

enthalten.

Weitere Attribute (z.B. `message`) können flexibel hinzugefügt werden.

Durch das serverlose Modell entstehen nur Kosten bei tatsächlicher Nutzung, was dieses Setup gut für Übungen und Tests geeignet macht.
