

output "webshop_public_dns" {
  description = "Public DNS der Webshop-Instanz"
  value       = data.terraform_remote_state.infrastructure.outputs.webshop_public_dns
}