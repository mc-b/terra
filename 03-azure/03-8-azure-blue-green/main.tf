locals {
  prefix_compact = lower(replace(var.name_prefix, "-", ""))
}

data "azurerm_resource_group" "rg" {
  name = "${var.name_prefix}-rg"
}

resource "random_string" "tm_suffix" {
  length  = 6
  upper   = false
  numeric = false
  special = false
}

resource "random_string" "tm_dns_suffix" {
  length  = 6
  upper   = false
  numeric = false
  special = false
}

resource "azurerm_traffic_manager_profile" "profile" {
  name = substr(
    "${local.prefix_compact}tm${random_string.tm_suffix.result}",
    0,
    63
  )

  resource_group_name    = data.azurerm_resource_group.rg.name
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = substr(
      "${local.prefix_compact}tm${random_string.tm_dns_suffix.result}",
      0,
      63
    )
    ttl = 30
  }

  monitor_config {
    protocol                    = "HTTP"
    port                        = 80
    path                        = "/"
    expected_status_code_ranges = ["200-202", "301-302"]
  }
}

resource "azurerm_traffic_manager_external_endpoint" "blue" {
  profile_id = azurerm_traffic_manager_profile.profile.id
  name       = "blue"

  target = "${local.prefix_compact}blue.z1.web.core.windows.net"
  weight = 500
}

resource "azurerm_traffic_manager_external_endpoint" "green" {
  profile_id = azurerm_traffic_manager_profile.profile.id
  name       = "green"

  target = "${local.prefix_compact}green.z1.web.core.windows.net"
  weight = 500
}