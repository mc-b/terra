Terraform
=========

Testumgebung zum Kurs: [Infrastructure as Code mit Terraform (Terra)](https://github.com/mc-b/terra).

Dashboard bzw. neu Headlamp
---------------------------

Das Kubernetes Dashboard/Headlamp ist wie folgt erreichbar:

    https://${fqdn}:30443
    http://${fqdn}:30444
    
Zugriffstoken für Headlamp erstellen:

    kubectl create token Headlamp-admin -n kube-system   

Beispiele
---------

Die Umgebung beinhaltet eine Vielzahl von Beispielen als Juypter Notebooks. Die Jupyter Lab Oberfläche ist wie folgt erreichbar:

    http://${control}:32188/lab/tree/terra  - Jupyter Lab Oberfläche
    http://${control}:8200                  - HashiCorp Vault (token: insecure)
    http://${control}:9999                  - GitLab (User: root, Password: sudo cat /etc/gitlab/initial_root_password  | grep Password:)
