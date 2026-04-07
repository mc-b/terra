
output "function_app_name" {
  value = azurerm_linux_function_app.func.name
}

output "function_default_hostname" {
  value = azurerm_linux_function_app.func.default_hostname
}

output "function_url" {
  value = "https://${azurerm_linux_function_app.func.default_hostname}/api/HttpExample"
}
