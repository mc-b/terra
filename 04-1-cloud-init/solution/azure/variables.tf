
# Allgemeine Variablen

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "West Europe"
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


