# Zugriffs Informationen
#
# Werden fuer die MAAS Umgebung benoetigt. 

variable "url" {
  description = "Evtl. URL fuer den Zugriff auf das API des Racks Servers"
  type        = string
  default     = "unknown"
}

# Umgebungsvariable TF_VAR_key ablegen
variable "key" {
  description = "API Key, Token etc. fuer Zugriff"
  type        = string
  sensitive   = true
  default     = "unknown"
}

variable "vpn" {
  description = "Optional VPN welches eingerichtet werden soll"
  type        = string
  default     = "unknown"
}

variable "host_no" {
  description = "Host-No fuer die erste Host-IP Nummer"
  type        = number
  default     = 10
}
