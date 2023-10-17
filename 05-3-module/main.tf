
module "myvm" {
  source     = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure"

  module      = "myvm-${terraform.workspace}"
  description = "Meine VM"
  userdata    = "cloud-init.yaml"
}

