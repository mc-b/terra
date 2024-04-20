## Beispiele 04-2-meta-data: Cloud Meta-Data ohne Cloud-init


### [Beispiel](https://github.com/mc-b/duk/blob/master/scripts/install.sh) Azure Cloud

Abfragen ob wir uns in der Azure Cloud befinden und wenn ja, Public IP-Adresse ausgeben.

**Bash Script**

    RC=$(curl -w "%{http_code}" -o /dev/null -s --max-time 3 -H Metadata:true --noproxy "*" 'http://169.254.169.254/metadata/instance/network/interface?api-version=2021-02-01')
    if [ "$RC" == "200" ]
    then
        curl -s --max-time 2 -H Metadata:true --noproxy "*" 'http://169.254.169.254/metadata/instance/network?api-version=2021-02-01' | jq '.interface[0].ipv4.ipAddress[0].publicIpAddress'  
    fi
    
**PowerShell (Übersetzt von ChatGPT)**

    # HTTP-Anfrage senden und den HTTP-Statuscode erhalten
    $response = Invoke-WebRequest -Uri "http://169.254.169.254/metadata/instance/network/interface?api-version=2021-02-01" -Method 'Head' -Headers @{"Metadata"="true"} -MaximumRedirection 0 -TimeoutSec 3 -ErrorAction SilentlyContinue
    
    if ($response.StatusCode -eq 200) {
        # Wenn der Statuscode 200 ist, die öffentliche IP-Adresse abrufen
        Invoke-WebRequest -Uri "http://169.254.169.254/metadata/instance/network?api-version=2021-02-01" -Headers @{"Metadata"="true"} -TimeoutSec 2 | Select-Object -ExpandProperty Content | ConvertFrom-Json | Select-Object -ExpandProperty interface | Select-Object -First 1 | Select-Object -ExpandProperty ipv4 | Select-Object -ExpandProperty ipAddress | Select-Object -First 1
    }

### [Beispiel](https://github.com/mc-b/duk/blob/master/scripts/install.sh) AWS Cloud

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
    
    
### Google Cloud (von ChatGPT erstellt)

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
    
    