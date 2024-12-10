
# Allgemeine Variablen

variable "image" {
  description = "Image Id"
  type        = string
  default     = "ami-083654bd07b5da81d"
}

# Scripts

data "template_file" "webshop" {
  template = file("${path.module}/../scripts/webshop.yaml")
}
