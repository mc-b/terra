## Übung 06-2: Secrets - Kubernetes

**Kubernetes Zugriff einrichten**: siehe [06-1-remote-state-k8s](../06-1-remote-state-k8s)

### Übung  

Zuerst müssen wir ein Kubernetes Secret mit Password und SSH-Key anlegen.

    kubectl create secret generic my-secret   \
    --from-literal=password=insecure   \
    --from-literal=ssh_key='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUHol1mBvP5Nwe3Bzbpq4GsHTSw96phXLZ27aPiRdrzhnQ2jMu4kSgv9xFsnpZgBsQa84EhdJQMZz8EOeuhvYuJtmhAVzAvNjjRak+bpxLPdWlox1pLJTuhcIqfTTSfBYJYB68VRAXJ29ocQB7qn7aDj6Cuw3s9IyXoaKhyb4n7I8yI3r0U30NAcMjyvV3LYOXx/JQbX+PjVsJMzp2NlrC7snz8gcSKxUtL/eF0g+WnC75iuhBbKbNPr7QP/ItHaAh9Tv5a3myBLNZQ56SgnSCgmS0EUVeMNsO8XaaKr2H2x5592IIoz7YRyL4wlOmj35bQocwdahdOCFI7nT9fr6f insecure@lerncloud'
    
Anschliessend können wir ganz normal die Ressourcen mit Terraform erstellen.

    terraform init
    terraform apply -auto-approve 
    
Das Ergebnis können wir in der Datei `rendered-cloud-init.yaml` anschauen.
    
Die Original Cloud-init Datei [webshop.tpl](../scripts/webshop.tbl) enthält keine geheimen Werte, sondern diese werden von Kubernetes geholt.

    #cloud-config
    hostname: webshop
    users:
      - name: ubuntu
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: users, admin
        shell: /bin/bash
        lock_passwd: false
        plain_text_passwd: ${password}       
        ssh_authorized_keys:
          - ${ssh_key}
    ...
    
Und [main.tf](main.tf):
    
    data "kubernetes_secret" "my_secret" {
      metadata {
        name      = "my-secret"
        namespace = "default"
      }
    }
    
    # Besser waere template_file aber so kann man es debuggen
    resource "local_file" "cloud_init" {
      filename = "rendered-cloud-init.yaml"
      content = templatefile("../scripts/webshop.tpl", {
        password = data.kubernetes_secret.my_secret.data["password"]
        ssh_key  = data.kubernetes_secret.my_secret.data["ssh_key"]
      })
    }    