
# Allgemeine Variablen

variable "image" {
  description = "Image Id"
  type        = string
  default     = "ami-083654bd07b5da81d"
}

variable "environment" {
  type = string
}

# Scripts

data "template_file" "order" {
  template = file("${path.module}/scripts/order.yaml")
  vars = {
    environment = var.environment
  }
}

data "template_file" "customer" {
  template = file("${path.module}/scripts/customer.yaml")
  vars = {
    environment = var.environment
  }
}

data "template_file" "catalog" {
  template = file("${path.module}/scripts/catalog.yaml")
  vars = {
    environment = var.environment
  }
}

data "template_file" "webshop" {
  template = file("${path.module}/scripts/webshop.yaml")
  vars = {
    environment = var.environment
  }

}
