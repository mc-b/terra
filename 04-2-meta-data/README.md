## Beispiele 04-2-meta-data: Cloud Meta-Data ohne Cloud-init

Für die Linux Übung muss zuerst eine Linux VM in der Cloud erstellt werden.

Für die Übungen mit PowerShell zuerst eine Windows VM in der Cloud erstellt werden, z.B. über das Web UI.

**Die Befehle müssen in dieser VM ausgeführt werden!**

### Übungen

#### [Beispiel](https://github.com/mc-b/duk/blob/master/scripts/install.sh) Azure Cloud

Abfragen ob wir uns in der Azure Cloud befinden und wenn ja, Public IP-Adresse ausgeben.

**Bash Script**

    RC=$(curl -w "%{http_code}" -o /dev/null -s --max-time 3 -H Metadata:true --noproxy "*" 'http://169.254.169.254/metadata/instance/network/interface?api-version=2021-02-01')
    if [ "$RC" == "200" ]
    then
        curl -s --max-time 2 -H Metadata:true --noproxy "*" 'http://169.254.169.254/metadata/instance/network?api-version=2021-02-01' | jq '.interface[0].ipv4.ipAddress[0].publicIpAddress'  
    fi
    
**PowerShell**

    # Definieren der URL für die Azure Instance Metadata Service
    $metadataUrl = "http://169.254.169.254/metadata/instance?api-version=2021-02-01"

    # Erstellen der Webanforderung mit den erforderlichen Headern
    $response = Invoke-RestMethod -Uri $metadataUrl -Method Get -Headers @{"Metadata"="true"} -MaximumRedirection 0 -TimeoutSec 3 -ErrorAction SilentlyContinue
    # Wenn der Statuscode 200 ist, Informationen anzeigen
    if ($response.StatusCode -eq 200) {
        Invoke-WebRequest -Uri $metadataUrl -Headers @{"Metadata"="true"} -TimeoutSec 2 | Select-Object -ExpandProperty Content 
    }

#### [Beispiel](https://github.com/mc-b/duk/blob/master/scripts/install.sh) AWS Cloud

Abfragen ob wir uns in der AWS Cloud befinden und wenn ja, Public DNS Name ausgeben.

**Bash Script**

    RC=$(curl -w "%{http_code}" -o /dev/null -s --max-time 3 http://169.254.169.254/latest/meta-data/public-hostname)
    if [ "$RC" == "200" ]
    then
        curl -s --max-time 2 http://169.254.169.254/latest/meta-data/public-hostname 
    fi
    
**PowerShell (Übersetzt von ChatGPT)**

    # HTTP-Anfrage senden und den HTTP-Statuscode erhalten
    $response = Invoke-WebRequest -Uri "http://169.254.169.254/latest/meta-data/public-hostname" -Method 'Head' -MaximumRedirection 0 -TimeoutSec 3 -ErrorAction SilentlyContinue
    
    if ($response.StatusCode -eq 200) {
        # Wenn der Statuscode 200 ist, die öffentliche Hostname-Informationen abrufen
        Invoke-WebRequest -Uri "http://169.254.169.254/latest/meta-data/public-hostname" -TimeoutSec 2
    }
    
#### Google Cloud (von ChatGPT erstellt)

**Bash Script**

    # HTTP-Anfrage senden und den HTTP-Statuscode erhalten
    RC=$(curl -w "%{http_code}" -o /dev/null -s --max-time 3 -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
    
    if [ "$RC" == "200" ]; then
        # Wenn der Statuscode 200 ist, die externe IP-Adresse abrufen
        curl -s --max-time 2 -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip
    fi
    
**PowerShell**

    # HTTP-Anfrage senden und den HTTP-Statuscode erhalten
    $response = Invoke-WebRequest -Uri "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -Headers @{"Metadata-Flavor"="Google"} -Method 'Head' -MaximumRedirection 0 -TimeoutSec 3 -ErrorAction SilentlyContinue
    
    if ($response.StatusCode -eq 200) {
        # Wenn der Statuscode 200 ist, die externe IP-Adresse abrufen
        Invoke-WebRequest -Uri "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -Headers @{"Metadata-Flavor"="Google"} -TimeoutSec 2 | Select-Object -ExpandProperty Content
}
    
    