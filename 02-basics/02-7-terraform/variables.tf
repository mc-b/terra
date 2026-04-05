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

variable "memory" {
  description = "Memory in GB: bestimmt Instance in der Cloud"
  type        = number
  default     = 2
}

variable "storage" {
  description = "Groesse Disk"
  type        = number
  default     = 32
}

variable "cores" {
  description = "Anzahl CPUs"
  type        = number
  default     = 1
}

variable "userdata_web" {
  description = "Cloud-init Script"
  type        = string
  default     = "cloud-init-php.yaml"
}

variable "userdata_mysql" {
  description = "Cloud-init Script"
  type        = string
  default     = "cloud-init-mysql.yaml"
}
