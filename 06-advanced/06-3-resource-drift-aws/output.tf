

output "security_group_id" {
  description = "Security Group Id"
  value       = aws_security_group.webshop.id
}

output "webshop_public_dns" {
  description = "Public DNS der Webshop-Instanz"
  value       = aws_instance.webshop.public_dns
}
