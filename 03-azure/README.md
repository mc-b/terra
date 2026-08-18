# Azure

Für die Übungen wird [VSCode](https://code.visualstudio.com/), benötigt. Diese Anleitung steht in der Datei [README.md](README.md). Die Eingaben finden im integrierten Terminalfenster statt, in dem Verzeichnis wo sich auch die Übungendateien befinden.

Ausserdem muss das [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) installiert sein.

## Bereitgestellte Azure-Zugangsdaten und Login-Einrichtung

Für die Übungen 1 bis 5 arbeitest du mit den vom Trainer bereitgestellten Azure-Zugangsdaten.

**Microsoft Authenticator App vorbereiten**

* Lade die Microsoft Authenticator App auf dein Smartphone herunter.
* Die App gibt es im Google Play Store oder Apple App Store. 

**Skript kopieren und neu ausführen**

* Kopiere das Verzeichnis azure/student aus den Unterlagen in dein Arbeitsverzeichnis.
* Führe den passenden Befehl aus, um die Umgebung neu zu laden und den ersten Login zu starten:
* Git Bash

```
source student/studentXX.sh
```

* PowerShell

```
. \student\studentXX.ps1
```

**Erster Login und MFA aktivieren**

* Das Skript öffnet nun den Login (oder fordert dich im Terminal dazu auf).
* Melde dich mit deinen Zugangsdaten an.
* Scanne den angezeigten QR-Code mit der Authenticator App auf deinem Smartphone.
* Folge den Anweisungen, um die Multi-Faktor-Authentifizierung (MFA) einzurichten.

**Skript nochmals ausführen (Erneuter Login)**

* Führe das Skript nun ein zweites Mal im Terminal aus:


* Git Bash: `source student/studentXX.sh`
* PowerShell: `. \student\studentXX.ps1`

* Bestätige den Login dieses Mal direkt über die Microsoft Authenticator App auf deinem Smartphone. 

## Alternative: Eigener Azure Account einrichten (Nur für virtuelle Maschinen)

**WICHTIGER UNTERSCHIED**: Für die meisten Übungen nutzt du die Zugangsdaten vom Trainer. Sobald du jedoch mit virtuellen Maschinen (VMs) arbeitest, reichen diese nicht mehr aus. In diesem Fall darfst du nicht das Skript des Trainers nutzen, sondern benötigst zwingend einen eigenen, persönlichen Azure-Account.

Falls du noch keinen privaten oder geschäftlichen Account besitzt, musst du diesen zuerst erstellen. Nutze dafür diesen Link: [Kostenloses Azure-Konto erstellen](https://azure.microsoft.com/free/).

**Was ändert sich bei der Einrichtung?**

Die Schritte für die Microsoft Authenticator App und die Aktivierung der MFA bleiben genau gleich wie oben beschrieben. 
Der einzige Unterschied liegt im Terminal-Befehl: Statt das Skript des Trainers zu laden, nutzt du direkt den Login-Befehl der Azure CLI.

    az login

   