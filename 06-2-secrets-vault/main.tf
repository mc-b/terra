
# Network

# Security

data "vault_generic_secret" "my_secret" {
  path = "secret/my-secret"  # Pfad zu ssh-key und password
}

# Besser waere template_file aber so kann man es debuggen
resource "local_file" "cloud_init" {
  filename = "rendered-cloud-init.yaml"
  content = templatefile("../scripts/webshop.tpl", {
    password = data.vault_generic_secret.my_secret.data["password"]
    ssh_key  = data.vault_generic_secret.my_secret.data["ssh_key"]
  })
}

# Reverse Proxy




