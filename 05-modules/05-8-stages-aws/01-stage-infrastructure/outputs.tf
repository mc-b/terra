

output "webshop_public_dns" {
  description = "Public DNS der Webshop-Instanz"
  value       = module.routing.webshop_public_dns
}

# Aufbereitung fuer 02-stage-application

output "intern_security_group_id" {
  description = "ID of the internal security group created by the security module"
  value       = module.security.intern_security_group_id
}

output "intern_subnet_id" {
  description = "ID of the internal subnet created by the network module"
  value       = module.network.intern_subnet_id
}

