###
#   Outputs wie IP-Adresse und DNS Name
#  

# Outputs unformatiert

output "ip_vm_web" {
  value       = var.name_web
  description = "The IP address of the server instance."
}

output "fqdn_vm_web" {
  value       = format("%s.mshome.net", var.name_web)
  description = "The FQDN of the server instance."
}

output "ip_vm_mysql" {
  value       = var.name_mysql
  description = "The IP address of the server instance."
}

output "fqdn_vm_mysql" {
  value       = format("%s.mshome.net", var.name_mysql)
  description = "The FQDN of the server instance."
}

# Outputs als Einfuehrungsseite

output "README" {
  value = templatefile("INTRO.md", { ip = var.name_web, fqdn = format("%s.mshome.net", var.name_web), mysql = format("%s.mshome.net", var.name_mysql), mysql_ip = var.name_mysql })
}
