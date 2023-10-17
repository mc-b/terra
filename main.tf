###
#   GitLab Umgebung
#

module "git" {

  #source     = "./terraform-lerncloud-module"
  source = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"  
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure" 
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-proxmox"      

  module      = "git-${var.host_no + 1}-${terraform.workspace}"
  description = "GitLab"
  userdata    = "cloud-init-git.yaml"

  cores   = 2
  memory  = 8
  storage = 32
  ports   = [22, 80]

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn
}
