
data "aws_caller_identity" "current" {}


locals {
  function_name = "${var.name_prefix}-hello"
}

variable "name_prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
