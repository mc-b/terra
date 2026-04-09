
data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${var.name_prefix}-${data.aws_caller_identity.current.account_id}-${var.environment}"
  html_path   = "${path.module}/environments/${var.environment}"
}

variable "environment" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
