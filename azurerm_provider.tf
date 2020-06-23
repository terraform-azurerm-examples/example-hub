provider "azurerm" {
  version             = "~> 2.15"
  storage_use_azuread = true

  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  subscription_id = var.subscription_id
  client_id       = data.azurerm_key_vault_secret.client_id.value
  client_secret   = data.azurerm_key_vault_secret.client_secret.value
}
