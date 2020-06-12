provider "azurerm" {
  version             = "~> 2.12.0"
  storage_use_azuread = true // export ARM_STORAGE_USE_AZUREAD=true

  features {}

  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = try(data.azurerm_key_vault_secret.client_secret.value, var.client_secret)
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

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
