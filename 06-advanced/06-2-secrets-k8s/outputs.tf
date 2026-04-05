

output "webshop_public_dns" {
  description = "Public DNS der Webshop-Instanz"
  value       = module.routing.webshop_public_dns
}
