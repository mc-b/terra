output "storage_account_name" {
  description = "Name des Storage Accounts"
  value       = azurerm_storage_account.blue.name
}

output "primary_web_endpoint" {
  description = "Primärer Endpoint der statischen Website"
  value       = azurerm_storage_account.blue.primary_web_endpoint
}

output "website_url" {
  description = "URL der statischen Website"
  value       = azurerm_storage_account.blue.primary_web_endpoint
}