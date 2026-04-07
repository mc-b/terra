
variable "name_prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "Switzerland North"
}