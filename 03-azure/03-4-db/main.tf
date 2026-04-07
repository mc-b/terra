data "azurerm_resource_group" "main" {
  name = "${var.name_prefix}-rg"
}

resource "azurerm_storage_account" "db" {
  name                     = substr(lower(replace("${var.name_prefix}db", "-", "")), 0, 24)
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.common_tags
}

resource "azurerm_storage_table" "example" {
  name                 = "studenttable"
  storage_account_name = azurerm_storage_account.db.name
}
