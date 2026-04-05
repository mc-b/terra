
data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${var.name_prefix}-${data.aws_caller_identity.current.account_id}"
}

variable "name_prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
