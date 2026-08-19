###
# Testumgebung Webseite mit PHP, Adminer und MySQL Umgebung
#
# Unterschied zu 02-1-terraform: triggers_replace erzwingt bei Namensänderung autom. Zerstörung und Neuerstellung der VM.

resource "terraform_data" "web" {
  triggers_replace = {
    name = var.name_web
  }

  # terraform apply
  provisioner "local-exec" {
    command    = "multipass launch --name ${var.name_web} -c${var.cores} -m${var.memory}GB -d${var.storage}GB --cloud-init ${var.userdata_web}"
    on_failure = continue
  }

  # terraform destroy
  provisioner "local-exec" {
    when       = destroy
    command    = "multipass delete ${self.output.name} --purge"
    on_failure = continue
  }
}

resource "terraform_data" "mysql" {
  triggers_replace = {
    name = var.name_mysql
  }

  # terraform apply
  provisioner "local-exec" {
    command    = "multipass launch --name ${var.name_mysql} -c${var.cores} -m${var.memory}GB -d${var.storage}GB --cloud-init ${var.userdata_mysql}"
    on_failure = continue
  }

  # terraform destroy
  provisioner "local-exec" {
    when       = destroy
    command    = "multipass delete ${self.output.name} --purge"
    on_failure = continue
  }
}
