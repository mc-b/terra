
output "webshop_public_ip" {
  description = "The Public IP address of the Webshop virtual machine."
  value       = azurerm_public_ip.pip.ip_address
}