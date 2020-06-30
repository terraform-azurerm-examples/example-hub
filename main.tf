data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "hub" {
  name     = var.hub
  location = var.location
  tags     = var.tags
}

resource "random_string" "hub" {
  length  = 10
  special = false
  upper   = false
  lower   = true
  number  = true
}

resource "azurerm_user_assigned_identity" "hub" {
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  tags                = azurerm_resource_group.hub.tags
  name                = "${var.hub}-${random_string.hub.result}"
}