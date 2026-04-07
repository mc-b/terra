data "azurerm_resource_group" "main" {
  name = "${var.name_prefix}-rg"
}

resource "azurerm_storage_account" "example" {
  name                     = substr(lower(replace("${var.name_prefix}sa", "-", "")), 0, 24)
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.common_tags
}

resource "azurerm_storage_account_static_website" "example" {
  storage_account_id = azurerm_storage_account.example.id
  index_document     = "index.html"
  error_404_document = "error.html"
}

resource "azurerm_storage_blob" "website_files" {
  for_each = {
    "index.html" = "../03-1-cli/site/index.html"
    "error.html" = "../03-1-cli/site/error.html"
  }

  name                   = each.key
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = each.value
  content_type           = "text/html"

  depends_on = [
    azurerm_storage_account_static_website.example
  ]
} 