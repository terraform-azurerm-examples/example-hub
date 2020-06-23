provider "azurerm" {
  // Uses the Azure CLI token (or env vars) unless managed identity is used
  features {}
  alias   = "backend"
  use_msi = false
}

data "azurerm_key_vault_secret" "client_id" {
  provider     = azurerm.backend
  key_vault_id = "/subscriptions/2ca40be1-7e80-4f2b-92f7-06b2123a68cc/resourceGroups/terraform/providers/Microsoft.KeyVault/vaults/terraformo7odvr3icext3gp"
  name         = "client-id"
}


data "azurerm_key_vault_secret" "client_secret" {
  provider     = azurerm.backend
  key_vault_id = "/subscriptions/2ca40be1-7e80-4f2b-92f7-06b2123a68cc/resourceGroups/terraform/providers/Microsoft.KeyVault/vaults/terraformo7odvr3icext3gp"
  name         = "client-secret"
}
