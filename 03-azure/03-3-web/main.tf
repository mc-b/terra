data "azurerm_resource_group" "main" {
  name = "${var.name_prefix}-rg"
}

resource "azurerm_storage_account" "green" {
  name                     = substr(lower(replace("${var.name_prefix}green", "-", "")), 0, 24)
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.common_tags
}

resource "azurerm_storage_account_static_website" "green" {
  storage_account_id = azurerm_storage_account.green.id
  index_document     = "index.html"
  error_404_document = "error.html"
}
