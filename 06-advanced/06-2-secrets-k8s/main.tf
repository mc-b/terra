
# Network

module "network" {
  source = "../05-6-modules-aws/modules/network"
}

# Security

module "security" {
  source = "../05-6-modules-aws/modules/security"
  vpc_id = module.network.vpc.id
}

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

# Reverse Proxy

module "routing" {
  source             = "../05-6-modules-aws/modules/routing"
  vpc_security_group = module.security.external_security_group_id
  subnet_id          = module.network.intern_subnet_id
  vpc                = module.network.vpc
  image              = var.image
  user_data          = local_file.cloud_init.content
}



