# Azure

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) installiert sein.

### bereitgestellte Azure-Zugangsdaten

Für die Übungen 1 bis 5 kannst du mit den vom Trainer bereitgestellten Azure-Zugangsdaten arbeiten.

Kopiere dazu aus den Unterlagen das Verzeichnis `azure/secrets` in dieses Arbeitsverzeichnis.

Anschliessend lädst du die passende Umgebung:

**Git Bash**

    source secrets/studentXX.sh

**PowerShell**

    secrets/studentXX.ps1
    

### Azure CLI einrichten (nur für virtuellen Maschinen)

Sobald du mit **virtuellen Maschinen (VMs) arbeitest, benötigst du einen eigenen Azure Account**. Falls du noch keinen hast, musst du diesen zuerst erstellen.    

Und einloggen

    az login
    