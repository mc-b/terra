## Übung 04-1-powershell: Cloud-init und PowerShell

Im Feld user.data wo üblicherweise eine Cloud-init Deklaration steht, kann für Windows VMs auch ein PowerShell Script angegeben werden.

Dazu ist der Eintrag mit 

    <powershell> … </powershell>
    
zu umschliessen.

Der Eintrag um den Chrome Browser zu installieren müsste laut ChatGPT wie folgt aussehen:

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

