
# Allgemeine Variablen

variable "image" {
  description = "Image Id"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2004-lts" # Beispiel für Ubuntu 20.04 LTS
}

# Scripts

data "template_file" "order" {
  template = file("${path.module}/../scripts/order.yaml")
}

data "template_file" "customer" {
  template = file("${path.module}/../scripts/customer.yaml")
}

data "template_file" "catalog" {
  template = file("${path.module}/../scripts/catalog.yaml")
}

data "template_file" "webshop" {
  template = file("${path.module}/../scripts/webshop.yaml")
}


