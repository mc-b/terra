# AWS

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [AWS CLI](https://aws.amazon.com/de/cli/) installiert sein.

### bereitgestellte AWS-Zugangsdaten

Für die Übungen 1 bis 5 kannst du mit den vom Trainer bereitgestellten AWS-Zugangsdaten arbeiten.

Kopiere dazu aus den Unterlagen das Verzeichnis `secrets` in dieses Arbeitsverzeichnis.

Anschliessend lädst du die passende Umgebung:

**Git Bash**

    source secrets/studentXX.sh

**PowerShell**

    secrets/studentXX.ps1

Danach kannst du mit den Übungen 1 bis 5 arbeiten. **Die untenstehenden Arbeiten entfallen.**

### AWS CLI einrichten (nur für virtuellen Maschinen)

Sobald du mit **virtuellen Maschinen (VMs) arbeitest, benötigst du einen eigenen AWS Account**. Falls du noch keinen hast, musst du diesen zuerst erstellen.

Zuerst muss AWS so konfiguriert werden, dass wir das AWS CLI verwenden können.

Die Schritte sind wie folgt:
* Anmelden in der AWS Console mittels Stammbenutzer (root)
* Pulldown rechts beim Usernamen -> Sicherheitsanmeldeinformationen
* Einen neuen Zugriffsschlüssel anlegen
* Id und Secret Access Key notieren, die brauchen wir für `aws configure` unten.

Einloggen in AWS Cloud

    aws configure
 
    AWS Access Key ID [****************WBM7]:
    AWS Secret Access Key [****************eKJA]:
    Default region name [us-east-1]:
    Default output format [None]: