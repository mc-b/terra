
output "storage_account_name" {
  description = "Name des Storage Accounts"
  value       = azurerm_storage_account.db.name
}

output "storage_account_id" {
  description = "ID des Storage Accounts"
  value       = azurerm_storage_account.db.id
}

output "storage_table_name" {
  description = "Name der Storage Table"
  value       = azurerm_storage_table.example.name
}

output "storage_table_id" {
  description = "ID der Storage Table"
  value       = azurerm_storage_table.example.id
}

output "storage_account_primary_access_key" {
  value     = azurerm_storage_account.db.primary_access_key
  sensitive = true
}