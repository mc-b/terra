module "myvm" {
  #source     = "mc-b/aws/lerncloud"
  #source     = "mc-b/azure/lerncloud"
  source = "mc-b/multipass/lerncloud"

  # Module Info
  module      = "myvm-${terraform.workspace}"
  description = "Meine VM"
  userdata    = "cloud-init.yaml"

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn
}