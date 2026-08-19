# Testumgebung Webseite mit PHP, Adminer und MySQL Umgebung

resource "terraform_data" "web" {
  input = var.name_web

  # terraform apply
  provisioner "local-exec" {
    command    = "multipass launch --name ${var.name_web} -c2 -m2GB -d32GB --cloud-init cloud-init-php.yaml"
    on_failure = continue
  }

  # terraform destroy
  provisioner "local-exec" {
    when       = destroy
    command    = "multipass delete ${self.output} --purge"
    on_failure = continue
  }
}

resource "terraform_data" "mysql" {
  input = var.name_mysql

  # terraform apply
  provisioner "local-exec" {
    command    = "multipass launch --name ${var.name_mysql} -c2 -m2GB -d32GB --cloud-init cloud-init-mysql.yaml"
    on_failure = continue
  }

  # terraform destroy
  provisioner "local-exec" {
    when       = destroy
    command    = "multipass delete ${self.output} --purge"
    on_failure = continue
  }
}
