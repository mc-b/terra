## Übung 01-3: Windows PowerShell

PowerShell (auch Windows PowerShell und PowerShell Core) ist ein plattformübergreifendes Framework von Microsoft zur Automatisierung, Konfiguration und Verwaltung von Systemen, das einen Kommandozeileninterpreter inklusive Skriptsprache bietet.

Die Übungen finden in der [Windows PowerShell Umgebung](https://git-scm.com/downloads) als Administrator statt. 

Ausserdem muss der Paket-Manager von Windows [winget](https://learn.microsoft.com/de-de/windows/package-manager/winget/#install-winget) installiert sein.

### Teil 1: winget Paket-Manager von Windows

Um diesen zu Testen installieren wir XML Notepad.

Öffnet Windows PowerShell, z.B. über das Windows Startmenü.

Führt folgenden Befehl aus:

    winget install --id=Microsoft.XMLNotepad  -e

Kontrolliert die Installation, in dem Ihr XML Notepad über das Windows Startmenü öffnet.

### Teil 2: Windows VM erstellen und XML Notepad installieren (von ChatGPT)

Dazu brauchen wir zuerst ein Boot Image für Hyper-V. Dieses kann z.B. mittels Azure Portal unter `Software` als ISO Image downgeladet werden.

Dann erstellen wir ein Installations Script `Install.ps1` mit folgendem Inhalt:

    # Funktion zum Installieren von XML Notepad mit winget
    function Install-XMLNotepad {
        # Überprüfe, ob winget auf dem System verfügbar ist
        if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
            Write-Host "Error: Windows Package Manager (winget) is not installed or not available on this system."
            return
        }

        # Installiere XML Notepad mit winget
        winget install "Microsoft.XMLNotepad"
        
        # Überprüfe, ob XML Notepad erfolgreich installiert wurde
        if (Test-Path "$env:ProgramFiles\Microsoft XML Notepad\XMLNotepad.exe") {
            Write-Host "XML Notepad wurde erfolgreich installiert."
        } else {
            Write-Host "Fehler: XML Notepad konnte nicht installiert werden."
        }
    }

    # Installiere XML Notepad mit winget
    Install-XMLNotepad

Anschliessend kann die VM Eingerichtet und Gestartet werden:


    New-VM -Name "Windows10VM" -MemoryStartupBytes 4GB -BootDevice CD -SwitchName "Default Switch"
    Add-VMDvdDrive -VMName "Windows10VM" -Path "C:\Users\Public\Documents\en-us_windows_10.iso"
    Start-VM -Name "Windows10VM"
    
    Get-VMConsole -Name "Windows10VM" | Wait-VM
    
    $VM = Get-VM -Name "Windows10VM"
    $VM | Start-VM
    $VM | Get-VMConsole | Wait-VM  
    
Eine Session zur VM aufgebaut werden und das Installationsscript `Install.ps1` ausgeführt werden.    
    
    $Session = New-PSSession -VMName "Windows10VM"
    Copy-Item -Path $ScriptPath -ToSession $Session -Destination "C:\"
    Invoke-Command -Session $Session -ScriptBlock { Invoke-Expression -Command "C:\$(Split-Path -Leaf $using:ScriptPath)" }
    Remove-PSSession -Session $Session    

### Alternative: Script von ChatGPT

ChatGPT bei weiteren Versuchen schlug ChatGPT das Script [CreateVM.ps1](CreateVM.ps1) vor.

Kann wie nachfolgende beschrieben Gestartet werden und erzeugt eine VM in Hyper-V ohne Boot Disk. 

    PowerShell.exe -ExecutionPolicy Bypass -File "CreateVM.ps1"




