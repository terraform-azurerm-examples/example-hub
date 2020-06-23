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
