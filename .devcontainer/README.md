Dev Container
-------------

Dev Container sind eine Methode, um Entwicklungsumgebungen konsistent, reproduzierbar und versionskontrolliert bereitzustellen. 

Die gesamte benötigte Toolchain – etwa Laufzeitumgebungen, Abhängigkeiten, Compiler und Konfigurationen – wird dabei in einem Container definiert und versioniert. 

Entwickler arbeiten nicht mehr direkt auf dem lokalen System, sondern in einer klar abgegrenzten, identischen Umgebung.

### Container builden

    cd .devcontainer
    podman build -t ghcr.io/mc-b/terra:1.0.0 .
    
### Container verwenden

VS Code starten und das **terra**-Verzeichnis öffnen. 

Es erscheint ein Dialog, der anbietet, das Projekt **im Dev Container erneut zu öffnen** („Reopen in Container“). 

Nach Bestätigung baut Visual Studio Code den Container gemäss der Dev-Container-Konfiguration und verbindet die Entwicklungsumgebung automatisch damit. 

Ab diesem Zeitpunkt arbeitet man vollständig innerhalb des Containers, inklusive Shell, Tools und Extensions, ohne das lokale System weiter konfigurieren zu müssen.

