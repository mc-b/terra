
resource "azurerm_resource_group" "rg" {
  name     = "webshop-lb"
  location = var.resource_group_location
}

resource "random_string" "azurerm_traffic_manager_profile_name" {
  length  = 25
  upper   = false
  numeric = false
  special = false
}

resource "random_string" "azurerm_traffic_manager_profile_dns_config_relative_name" {
  length  = 10
  upper   = false
  numeric = false
  special = false
}

resource "azurerm_traffic_manager_profile" "profile" {
  name                   = random_string.azurerm_traffic_manager_profile_name.result
  resource_group_name    = azurerm_resource_group.rg.name
  traffic_routing_method = "Weighted"
  dns_config {
    relative_name = random_string.azurerm_traffic_manager_profile_dns_config_relative_name.result
    ttl           = 30
  }

  monitor_config {
    protocol                    = "HTTP"
    port                        = 80
    path                        = "/"
    expected_status_code_ranges = ["200-202", "301-302"]
  }
}

resource "azurerm_traffic_manager_external_endpoint" "blue" {
  profile_id        = azurerm_traffic_manager_profile.profile.id
  name              = "blue"
  target            = "52.242.72.144"
  endpoint_location = "eastus"
  weight            = 500
}

resource "azurerm_traffic_manager_external_endpoint" "green" {
  profile_id        = azurerm_traffic_manager_profile.profile.id
  name              = "green"
  target            = "172.200.12.135"
  endpoint_location = "eastus"
  weight            = 500
}