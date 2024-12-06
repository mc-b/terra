
# Allgemeine Variablen

variable "image" {
  description = "Image Id"
  type        = string
  default     = "ami-083654bd07b5da81d"
}

# Scripts

data "template_file" "order" {
  template = file("${path.module}/../../scripts/order.yaml")
}

data "template_file" "customer" {
  template = file("${path.module}/../../scripts/customer.yaml")
}

data "template_file" "catalog" {
  template = file("${path.module}/../../scripts/catalog.yaml")
}


