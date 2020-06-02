
provider "azurerm" {
  // Uses the Azure CLI token (or env vars) unless managed identity is used
  features {}
  alias   = "backend"
  use_msi = false
}

data "azurerm_key_vault_secret" "client_secret" {
  provider     = azurerm.backend
  key_vault_id = "/subscriptions/2d31be49-d959-4415-bb65-8aec2c90ba62/resourceGroups/terraform/providers/Microsoft.KeyVault/vaults/terraformsx80gl24bpp83fh"
  name         = "client-secret"
}
