## Übung 03-3-visualisierung: Visualisierung von Azure und Terraform Ressourcen

Während Terraform eine leistungsstarke Lösung für die Bereitstellung und Verwaltung von Infrastruktur bietet, kann die Komplexität der erstellten Umgebungen mit der Anzahl und Vielfalt der Ressourcen schnell zunehmen. In solchen Szenarien wird die Visualisierung der Terraform-Ressourcen zu einem unverzichtbaren Werkzeug, um die Struktur und Beziehungen zwischen den verschiedenen Komponenten klar zu verstehen.

* Übersichtliche Darstellung: Eine grafische Darstellung der Infrastruktur ermöglicht es den Teams, die Interaktionen zwischen den Ressourcen zu visualisieren und zu verstehen, was zu einer verbesserten Kommunikation und Zusammenarbeit führt.
* Fehlererkennung und Debugging: Durch die Visualisierung können potenzielle Fehler oder Inkonsistenzen in der Infrastrukturkonfiguration leichter identifiziert und behoben werden.
* Planung und Optimierung: Die Visualisierung ermöglicht es den Teams, die Infrastrukturarchitektur zu analysieren und potenzielle Optimierungen oder Skalierungsmöglichkeiten zu erkennen.

Für die Übung sind die CLI für Azure und Terraform zu installieren.

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
* [Terraform Installation](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)

Und die Visualisierungtools von Graphviz

* [Graphviz](https://graphviz.org/download/)

### Vorgehen

Installiert [Graphviz](https://graphviz.org/download/), z.B. durch Downloaden und Entpacken der ZIP-Datei ins C:\bin. 
Erweitert die PATH-Variable um "C:\bin\Graphviz\bin".

Wechselt ins Verzeichnis `03-3-azure` und führt die nachfolgend aufgeführten Befehle aus.

**Visualisierung Zusammenhänge**

![](webshop-plan.png)

- - -

Zuerst erstellen wir ein Diagramm welche Ressourcen mit welchen zusammenhängen. Impliziert -type=apply.

    terraform graph -type=plan | dot -Tpng > webshop-plan.png

**Visualisierung Cycle**

![](webshop-cycles.png)

- - -

Dann ein Diagramm, in welcher Reihenfolge (Zyklus) die Ressourcen erstellt werden.


    terraform graph -draw-cycles | dot -Tpng > webshop-cycles.png

### Links

* [Dokumentation](https://developer.hashicorp.com/terraform/cli/commands/graph)

