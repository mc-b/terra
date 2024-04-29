## Beispiel 04-1-powershell: Cloud-init und PowerShell

Im Feld `user.data`, wo üblicherweise eine Cloud-init Deklaration steht, kann für Windows VMs auch ein PowerShell Script angegeben werden.

Dazu ist der Eintrag mit 

    <powershell> … </powershell>
    
zu umschliessen.

Um z.B. den Chrome Browser zu installieren, ist folgendes im Feld `user.data` einzufügen:

    <powershell>
    # PowerShell-Skript, um Chrome herunterzuladen und zu installieren
    $url = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
    $output = "$env:TEMP\ChromeInstaller.msi"
    
    # Chrome herunterladen
    Invoke-WebRequest -Uri $url -OutFile $output
    
    # Chrome installieren
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $output /qn /norestart" -Wait
    
    # Aufräumen
    Remove-Item $output
    </powershell>
    
Azure Cloud erwartet das Script im Base64 Format

    PHBvd2Vyc2hlbGw+CiMgUG93ZXJTaGVsbC1Ta3JpcHQsIHVtIENocm9tZSBoZXJ1bnRlcnp1bGFk
    ZW4gdW5kIHp1IGluc3RhbGxpZXJlbgogPSAiaHR0cHM6Ly9kbC5nb29nbGUuY29tL2Nocm9tZS9p
    bnN0YWxsL0dvb2dsZUNocm9tZVN0YW5kYWxvbmVFbnRlcnByaXNlNjQubXNpIgogPSAiOlRFTVBc
    Q2hyb21lSW5zdGFsbGVyLm1zaSIKCiMgQ2hyb21lIGhlcnVudGVybGFkZW4KSW52b2tlLVdlYlJl
    cXVlc3QgLVVyaSAgLU91dEZpbGUgCgojIENocm9tZSBpbnN0YWxsaWVyZW4KU3RhcnQtUHJvY2Vz
    cyAtRmlsZVBhdGggIm1zaWV4ZWMuZXhlIiAtQXJndW1lbnRMaXN0ICIvaSAgL3FuIC9ub3Jlc3Rh
    cnQiIC1XYWl0CgojIEF1ZnLkdW1lbgpSZW1vdmUtSXRlbSAKPC9wb3dlcnNoZWxsPgo=    

**Hinweis** Evtl. nur erfolgreich in der AWS Cloud.