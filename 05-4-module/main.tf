module "myvm" {
  #source     = "mc-b/aws/lerncloud"
  #source     = "mc-b/azure/lerncloud"
  source = "mc-b/multipass/lerncloud"

  # Module Info
  module      = "myvm-${terraform.workspace}"
  description = "Meine VM"
  userdata    = "cloud-init.yaml"
  
  # Im Gegensatz zu git:: braucht es diese hier nochmals
  url   = ""
  key   = ""
  vpn   = ""
}