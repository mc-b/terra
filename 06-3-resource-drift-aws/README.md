## Übung 06-3: Resource Drift - AWS

### Übung

Beim Erstellen der Terraform Deklaration wurde vergessen den Port 80 zu öffnen.

Leider wurde die notwendige Änderung nicht in der Terraform Deklaration nachgeführt sondern mittels dem AWS CLI.

    aws ec2 authorize-security-group-ingress \
        --group-id sg-... \
        --protocol tcp \
        --port 80 \
        --cidr 0.0.0.0/0

Bei Ausführen von `terraform apply` wird die Änderung wieder rückgängig gemacht.

Mittels hinter anstellen von `-refresh only` bleibt die Änderung bestehen und die State Datei wird entsprechend nachgeführt.

Probiert `terraform plan` mit und ohne `-refresh only` und vergleicht die Ergebnisse.
