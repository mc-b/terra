
# Allgemeine Variablen

variable "image" {
  description = "Image Id"
  type        = string
  default     = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20240319" # Beispiel für Ubuntu 22.04 LTS
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


