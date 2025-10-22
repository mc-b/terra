
# Allgemeine Variablen

variable "image" {
  description = "Image Id"
  type        = string
  default     = "ami-083654bd07b5da81d"
}


# Scripts

data "local_file" "order" {
  filename  = "${path.module}/../scripts/order.yaml"
}

data "local_file" "customer" {
  filename  = "${path.module}/../scripts/customer.yaml"
}

data "local_file" "catalog" {
  filename  = "${path.module}/../scripts/catalog.yaml"
}

data "local_file" "webshop" {
  filename  = "${path.module}/../scripts/webshop.yaml"
}


