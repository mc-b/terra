###
#   Testumgebung Webseite mit PHP, Adminer und MySQL Umgebung

resource "null_resource" "web" {

  triggers = {
    name = var.name_web
  }

  # terraform apply
  provisioner "local-exec" {
    command    = "multipass launch --name ${var.name_web} -c2 -m2GB -d32GB --cloud-init cloud-init-php.yaml"
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
    command    = "multipass launch --name ${var.name_mysql} -c2 -m2GB -d32GB --cloud-init cloud-init-mysql.yaml"
    on_failure = continue
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "multipass delete ${self.triggers.name} --purge"
    on_failure = continue
  }
}
