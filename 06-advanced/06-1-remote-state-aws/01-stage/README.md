## AWS S3 Bucket

### Einleitung

Amazon Simple Storage Service (S3) ist ein skalierbarer Objektspeicher, der häufig zur Speicherung und Archivierung von Daten in der Cloud verwendet wird. Ein S3-Bucket ist eine Container-Ressource, in der Objekte (Dateien) gespeichert werden. Unternehmen und Entwickler verwenden S3-Buckets zur Speicherung von Anwendungsdaten, Backups, Protokolldateien und auch zur Verwaltung des Terraform-Status (State-Files). Diese State-Dateien sind essenziell, um die Infrastruktur-Änderungen in Terraform nachzuvollziehen.

### Beschreibung der `main.tf`

Die `main.tf`-Datei enthält die vollständige Konfiguration eines AWS S3-Buckets, der für die Speicherung des Terraform-Status verwendet wird. Die Konfiguration ist modular aufgebaut, wobei jede Funktionalität (wie Verschlüsselung, Versionierung und Zugriffsbeschränkung) in separaten Ressourcen definiert ist. Dies macht die Konfiguration übersichtlicher und flexibler. Im Folgenden wird jede Ressource und ihre Funktion beschrieben:

1. **Haupt-S3-Bucket-Ressource**
   ```hcl
   resource "aws_s3_bucket" "terraform_state" {
     bucket = "mein-terraform-state-bucket"
   }
   ```
   Diese Ressource erstellt den Haupt-S3-Bucket mit dem Namen `mein-terraform-state-bucket`. Dieser Bucket speichert die Terraform-State-Dateien. Die optionale `lifecycle`-Konfiguration (auskommentiert) würde verhindern, dass der Bucket versehentlich gelöscht wird.

---

2. **Bucket-Besitzkontrollen (Ownership Controls)**
   ```hcl
   resource "aws_s3_bucket_ownership_controls" "terraform_state_ownership" {
     bucket = aws_s3_bucket.terraform_state.id

     rule {
       object_ownership = "BucketOwnerEnforced"
     }
   }
   ```
   Diese Ressource stellt sicher, dass der Bucket-Eigentümer automatisch der Besitzer aller Objekte ist, die in den Bucket hochgeladen werden. Dies verhindert, dass externe Benutzer mit eigenen Zugriffsrechten Objekte in den Bucket hochladen und die Kontrolle darüber behalten.

---

3. **Versionierung des Buckets**
   ```hcl
   resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
     bucket = aws_s3_bucket.terraform_state.id

     versioning_configuration {
       status = "Enabled"
     }
   }
   ```
   Diese Ressource aktiviert die **Versionierung** des Buckets. Das bedeutet, dass jede Änderung an einer Datei (z. B. der Terraform-State-Datei) als neue Version gespeichert wird. Dies ermöglicht es, frühere Versionen wiederherzustellen, falls ein Fehler auftritt oder Daten beschädigt werden.

---

4. **Lebenszyklus-Management**
   ```hcl
   resource "aws_s3_bucket_lifecycle_configuration" "terraform_state_lifecycle" {
     bucket = aws_s3_bucket.terraform_state.id

     rule {
       id     = "expire-old-versions"
       status = "Enabled"

       noncurrent_version_expiration {
         noncurrent_days = 30
       }
     }
   }
   ```
   Diese Ressource definiert **Lebenszyklus-Regeln** für den Bucket. In diesem Fall legt die Konfiguration fest, dass ältere Versionen von Objekten (Terraform-State-Dateien) nach 30 Tagen automatisch gelöscht werden. Dies spart Speicherkosten und hält den Bucket aufgeräumt.

---

5. **Server-Side-Verschlüsselung**
   ```hcl
   resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
     bucket = aws_s3_bucket.terraform_state.id

     rule {
       apply_server_side_encryption_by_default {
         sse_algorithm = "AES256"
       }
     }
   }
   ```
   Diese Ressource aktiviert die **Server-Side-Verschlüsselung** (SSE) für den S3-Bucket. Alle im Bucket gespeicherten Objekte werden standardmäßig mit dem AES-256-Algorithmus verschlüsselt. Dies stellt sicher, dass die Daten auch bei einem Sicherheitsvorfall (z. B. versehentliche öffentliche Freigabe) geschützt sind.

---

6. **Schutz vor öffentlichem Zugriff (Public Access Block)**
   ```hcl
   resource "aws_s3_bucket_public_access_block" "terraform_state_public_access_block" {
     bucket                  = aws_s3_bucket.terraform_state.id
     block_public_acls       = true
     block_public_policy     = true
     ignore_public_acls      = true
     restrict_public_buckets = true
   }
   ```
   Diese Ressource blockiert den **öffentlichen Zugriff** auf den S3-Bucket vollständig. Die einzelnen Parameter haben die folgende Bedeutung:
   - **block_public_acls**: Blockiert die Möglichkeit, ACLs zu erstellen, die öffentlichen Zugriff gewähren.
   - **block_public_policy**: Verhindert, dass öffentliche Richtlinien (Bucket Policies) angewendet werden.
   - **ignore_public_acls**: Ignoriert alle öffentlichen ACLs, selbst wenn sie hinzugefügt werden.
   - **restrict_public_buckets**: Verhindert, dass der Bucket für die Öffentlichkeit zugänglich gemacht wird.
