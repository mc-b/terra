## Übung 03-4: AWS - Einfache Datenbank mit DynamoDB

### Übung

Dieses Beispiel zeigt eine minimal konfigurierte NoSQL-Datenbank auf AWS mit Terraform/OpenTofu. Die Tabelle wird ohne feste Kapazitätsplanung betrieben und eignet sich für einfache Tests und kleine Anwendungen.

* Verständnis für NoSQL-Datenbanken (Key-Value)
* Arbeiten mit DynamoDB ohne Kapazitätsmanagement
* Persistente Datenspeicherung ohne Serverbetrieb

### Architektur

* **DynamoDB Table**: speichert Daten als Key-Value Einträge
* **On-Demand Billing**: automatische Skalierung ohne manuelle Konfiguration

Die Tabelle verwendet einen einfachen Primärschlüssel:

* **id (String)**: eindeutiger Schlüssel pro Eintrag

### Deployment

Starten mittels

    terraform init
    terraform apply -auto-approve

Die Tabelle wird anschliessend direkt in DynamoDB erstellt.

### Testen

Eintrag erstellen:

    aws dynamodb put-item \
      --table-name "${TF_VAR_name_prefix}-table" \
      --item '{"id": {"S": "1"}, "message": {"S": "hello"}}'

Eintrag lesen:

    aws dynamodb get-item \
      --table-name "${TF_VAR_name_prefix}-table" \
      --key '{"id": {"S": "1"}}'

### Wichtige Punkte

* Es wird **PAY_PER_REQUEST** verwendet (On-Demand)  → keine Provisionierung von Read/Write Capacity Units notwendig
* DynamoDB ist schemafrei (ausser dem Primärschlüssel)
* Zusätzliche Attribute (z.B. `message`) können flexibel gespeichert werden
* Die Tabelle ist vollständig serverlos und skaliert automatisch

### Verhalten der Ressourcen

Die Tabelle wird mit einem einzelnen Hash Key (`id`) erstellt. Jeder Eintrag muss diesen Schlüssel enthalten, weitere Attribute sind optional.

Durch das On-Demand Modell entstehen nur Kosten bei tatsächlicher Nutzung (Reads/Writes), was dieses Setup für Übungen und Tests geeignet macht.
