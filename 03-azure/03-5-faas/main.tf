data "azurerm_resource_group" "main" {
  name = "${var.name_prefix}-rg"
}

resource "azurerm_storage_account" "func" {
  name                     = substr(lower(replace("${var.name_prefix}funcsa", "-", "")), 0, 24)
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.common_tags
}

resource "azurerm_service_plan" "func" {
  name                = "${var.name_prefix}-func-plan"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"

  tags = var.common_tags
}

data "archive_file" "func_zip" {
  type        = "zip"
  source_dir  = "${path.module}/function-src"
  output_path = "${path.module}/function-src.zip"
}

resource "azurerm_linux_function_app" "func" {
  name                = "${var.name_prefix}-func"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location

  service_plan_id            = azurerm_service_plan.func.id
  storage_account_name       = azurerm_storage_account.func.name
  storage_account_access_key = azurerm_storage_account.func.primary_access_key

  zip_deploy_file = data.archive_file.func_zip.output_path

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }

  tags = var.common_tags
}
