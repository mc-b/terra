locals {
  prefix_compact = lower(replace(var.name_prefix, "-", ""))
}

data "azurerm_resource_group" "rg" {
  name = "${var.name_prefix}-rg"
}

resource "random_string" "afd_suffix" {
  length  = 6
  upper   = false
  numeric = false
  special = false
}

resource "random_string" "afd_endpoint_suffix" {
  length  = 6
  upper   = false
  numeric = false
  special = false
}

resource "azurerm_cdn_frontdoor_profile" "profile" {
  name                = substr("${local.prefix_compact}afd${random_string.afd_suffix.result}", 0, 260)
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = substr("${local.prefix_compact}afd${random_string.afd_endpoint_suffix.result}", 0, 50)
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
}

resource "azurerm_cdn_frontdoor_origin_group" "main" {
  name                     = "og-main"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id

  session_affinity_enabled = false

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required        = 3
  }

  health_probe {
    interval_in_seconds = 30
    path                = "/"
    protocol            = "Http"
    request_type        = "HEAD"
  }
}

resource "azurerm_cdn_frontdoor_origin" "blue" {
  name                          = "blue"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main.id

  enabled                        = true
  certificate_name_check_enabled = true

  host_name          = "${local.prefix_compact}blue.z1.web.core.windows.net"
  origin_host_header = "${local.prefix_compact}blue.z1.web.core.windows.net"

  http_port  = 80
  https_port = 443

  priority = 1
  weight   = 500
}

resource "azurerm_cdn_frontdoor_origin" "green" {
  name                          = "green"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main.id

  enabled                        = true
  certificate_name_check_enabled = true

  host_name          = "${local.prefix_compact}green.z1.web.core.windows.net"
  origin_host_header = "${local.prefix_compact}green.z1.web.core.windows.net"

  http_port  = 80
  https_port = 443

  priority = 1
  weight   = 500
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "route-all"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main.id
  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.blue.id,
    azurerm_cdn_frontdoor_origin.green.id
  ]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  link_to_default_domain = true
  enabled                = true
}