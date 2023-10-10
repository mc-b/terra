# Allgemeine Variablen
#
# Koennen mittels Umgebungsvariablen TF_VAR_<name> ueberschrieben werden.

variable "name_web" {
  description = "Hostname"
  type        = string
  default     = "web-61"
}

variable "name_mysql" {
  description = "Hostname"
  type        = string
  default     = "mysql"
}
