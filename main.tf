###
#   Terraform Umgebung
#

module "terra" {

  #source     = "./terraform-lerncloud-module"
  source = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"  
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure" 
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-proxmox"      

  module      = "dukmaster-${var.host_no}-${terraform.workspace}"
  description = "Terra"
  userdata    = "cloud-init.yaml"

  cores   = 4
  memory  = 12
  storage = 32
  ports   = [22, 80]

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn
}
