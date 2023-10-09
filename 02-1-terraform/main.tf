###
#   Testumgebung Webseite mit PHP, Adminer und MySQL Umgebung

resource "null_resource" "web" {

  triggers = {
    name = var.name_web
  }

  # terraform apply
  provisioner "local-exec" {
    command    = "multipass launch --name ${var.name_web} -c${var.cores} -m${var.memory}GB -d${var.storage}GB --cloud-init ${var.userdata_web}"
    on_failure = continue
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "multipass delete ${self.triggers.name} --purge"
    on_failure = continue
  }
}

resource "null_resource" "mysql" {

  triggers = {
    name = var.name_mysql
  }
  
  # terraform apply
  provisioner "local-exec" {
    command    = "multipass launch --name ${var.name_mysql} -c${var.cores} -m${var.memory}GB -d${var.storage}GB --cloud-init ${var.userdata_mysql}"
    on_failure = continue
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "multipass delete ${self.triggers.name} --purge"
    on_failure = continue
  }
}
