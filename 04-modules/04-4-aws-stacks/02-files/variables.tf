
data "aws_caller_identity" "current" {}

variable "name_prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "bucket_name" {
  type = string
}