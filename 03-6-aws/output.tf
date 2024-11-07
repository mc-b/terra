output "webshop_public_dns" {
  description = "Public DNS der Webshop-Instanz"
  value       = aws_instance.webshop.public_dns
}
