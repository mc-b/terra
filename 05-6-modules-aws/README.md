## Modules

![](https://developer.hashicorp.com/_next/image?url=https%3A%2F%2Fcontent.hashicorp.com%2Fapi%2Fassets%3Fproduct%3Dtutorials%26version%3Dmain%26asset%3Dpublic%252Fimg%252Fterraform%252Frecommended-patterns%252Fnetwork-module.png%26width%3D3305%26height%3D1676&w=3840&q=75&dpl=dpl_GALqHaXkWTJP2WQZx1hTcX21A5MZ)

Quelle [Terraform - Module creation - recommended pattern](https://developer.hashicorp.com/terraform/tutorials/modules/pattern-module-creation)

- - -

### Einleitung

Terraform-Module sind ein essenzieller Bestandteil zur Organisation, Wiederverwendung und Strukturierung von Infrastruktur-Code. Ein Modul ist eine Sammlung von Ressourcen, die zusammen eine bestimmte Funktionalität bereitstellen, wie z. B. ein Netzwerk, eine Datenbank oder eine Anwendung. Durch die Verwendung von Modulen kann komplexer Code in überschaubare, wiederverwendbare Einheiten aufgeteilt werden.

**Vorteile von Terraform-Modulen:**

- **Wiederverwendbarkeit:** Einmal erstellte Module können in verschiedenen Projekten oder Umgebungen wiederverwendet werden.
- **Übersichtlichkeit:** Der Code wird in logisch getrennte Abschnitte unterteilt, was die Lesbarkeit erhöht.
- **Wartbarkeit:** Änderungen können isoliert in einzelnen Modulen vorgenommen werden, ohne unbeabsichtigte Auswirkungen auf andere Teile der Infrastruktur.
- **Teamarbeit:** Mehrere Teammitglieder können parallel an unterschiedlichen Modulen arbeiten.

---

### Aufteilung von [03-6-aws/main.tf](../03-6-aws/main.tf) in Module

Die ursprüngliche [03-6-aws/main.tf](../03-6-aws/main.tf)-Datei für AWS enthält alle Ressourcen für die Bereitstellung der Infrastruktur in einer einzigen Datei. Um die Struktur zu verbessern und die Verwaltung zu erleichtern, haben wir die Ressourcen in folgende Module aufgeteilt:

1. **application/order**, **application/customer**, **application/catalog**
2. **network** (nur mit dem externen Netzwerk)
3. **routing** (mit der Webshop-VM, Netzwerk, interner Firewall)
4. **security** (mit der externen Firewall)

---

### **Übersicht der Ressourcen und deren Zuordnung zu Modulen**

| **Modul**                 | **Beschreibung**                                        | **Ressourcen**                                                                                         |
|---------------------------|--------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| **network**               | Externes Netzwerk                                       | - `aws_vpc.webshop`<br>- `aws_internet_gateway.webshop`                                           |
| **routing**               | Routing und internes Subnetz                            | - `aws_route.internet_access`<br>- `aws_subnet.webshop_intern`<br>- `aws_instance.webshop`     |
| **security**              | Externe und interne Security Groups                     | - `aws_security_group.webshop`<br>- `aws_security_group.webshop_intern`                         |
| **application/order**     | Anwendung "Order"                                       | - `aws_instance.order`                                                                          |
| **application/customer**  | Anwendung "Customer"                                    | - `aws_instance.customer`                                                                       |
| **application/catalog**   | Anwendung "Catalog"                                     | - `aws_instance.catalog`                                                                        |

---

### **Zusammenfassung**

Die Aufteilung der ursprünglichen `main.tf` in Module ermöglicht eine klarere Strukturierung und einfachere Verwaltung der Infrastruktur. Durch die logische Gruppierung der Ressourcen können wir:

- **Änderungen effizienter durchführen**, da Anpassungen in einem Modul keine unbeabsichtigten Auswirkungen auf andere Module haben.
- **Die Wiederverwendbarkeit erhöhen**, indem Module in anderen Projekten oder Kontexten wiederverwendet werden können.
- **Die Zusammenarbeit im Team verbessern**, da mehrere Personen gleichzeitig an verschiedenen Modulen arbeiten können.

Jedes Modul ist für eine spezifische Aufgabe verantwortlich, was die Fehlersuche erleichtert und die Wartung der Infrastruktur vereinfacht.




