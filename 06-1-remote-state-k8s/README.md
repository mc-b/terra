## Übung 06-1: Remote State Storage - Kubernetes

### Vorbereitung `k0s` Kubernetes

`.kube/config` Datei für User `ubuntu` zur Verfügung stellen

    mkdir -p ~/.kube
    sudo cp /var/lib/k0s/pki/admin.conf ~/.kube/config
    sudo chown ubuntu:ubuntu ~/.kube/config
    
    sudo snap install kubectl --classic
    
Die Datei `~/.kube/config` ist lokal auf den PC zu übertragen, z.B. `scp ubuntu@<k8s host>:./kube/config config`

### Übung   

    terraform init
    terraform apply -auto-approve 
    
Dank der `backend.tf` Datei wird die State Datei nicht mehr lokal sondern als Kubernetes `secret` -> `tfstate-default-state` gespeichert.   

    terraform {
      backend "kubernetes" {
        secret_suffix    = "state"
        config_path      = "~/.kube/config"
      }
    }
    
Anzeigen des `secret` in Kubernetes

    kubectl get secrets tfstate-default-state -o yaml 
    
### Links

* [Stores the state in a Kubernetes secret](https://developer.hashicorp.com/terraform/language/backend/kubernetes)